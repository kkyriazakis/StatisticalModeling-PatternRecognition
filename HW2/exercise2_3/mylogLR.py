from __future__ import print_function

import numpy as np
import tensorflow as tf

# Initializations
num_features = 2
output_dim = 1
batch_size = 10

# Variables of the model
W = tf.get_variable(name='W', shape=(num_features, output_dim), dtype=tf.float32, initializer=tf.contrib.layers.xavier_initializer())
b = tf.get_variable(name='b', shape=(output_dim, ), dtype=tf.float32, initializer=tf.constant_initializer(value=0, dtype=tf.float32))

# Input - output placeholders
X = tf.placeholder(shape=(batch_size, num_features), dtype=tf.float32)  # Placeholder for a batch of input vectors
Y = tf.placeholder(shape=(batch_size, output_dim), dtype=tf.float32)  # Placeholder for target values


# Normalize input data (standardization)
def normalize(xdata):
    global m, s  # The mean (m) and std (s) of the data (xdata)
    m = np.mean(xdata)   # mean
    s = np.std(xdata)  # standard deviation
    x_norm = (xdata - m)/s
    return x_norm


def inputs():
    # Load data
    fid = open('exam_scores_data1.txt', 'r')
    lines = fid.readlines()
    fid.close()
    input_list = []
    target_list = []
    for line in lines:
        fields = line.rstrip().split(',')
        input_list.append([float(fields[0]), float(fields[1])])
        target_list.append([float(fields[2])])

    X_np = np.array(input_list, dtype=np.float32)  # Matrix of input features. shape = (num_examples, num_features)
    Y_np = np.array(target_list, dtype=np.float32)  # Vector of target values. shape = (num_examples, )

    X_np = normalize(X_np)
    return X_np, Y_np


# Define the linear model
def combine_inputs(X):
    Y_predicted_linear = tf.matmul(X, W) + b  # The output of the linear model
    return Y_predicted_linear


# Define the sigmoid inference model over the data X and return the result
def inference(X):
    threshold = 0.5
    print("Binary Logistic Regression Evaluation with Threshold:", threshold)
    Y_inference = tf.sigmoid(combine_inputs(X))  # Defines the output of the sigmoid (Probability)
    Y_predicted = tf.cast(Y_inference > threshold, tf.float32)  # Binary prediction based on threshold
    return Y_inference, Y_predicted


# Compute the loss over the training data using the predictions and true labels Y
def loss(X, Y):
    Yhat = combine_inputs(X)
    SigCE = tf.nn.sigmoid_cross_entropy_with_logits(logits=Yhat, labels=Y)  # Sigmoid Cross Entropy
    loss = tf.reduce_mean(SigCE)  # Total Loss
    return loss


# Optimizer
def train(total_loss):
    learning_rate = 0.001
    optimizer = tf.train.GradientDescentOptimizer(learning_rate)
    # Get all variables created with trainable=True
    trainable_variables = tf.trainable_variables()
    update_op = optimizer.minimize(total_loss, var_list=trainable_variables)
    return update_op


# Evaluation on some Test Samples
def evaluate(Xtest, Ytest):
    Y_inference, Y_predicted = inference(Xtest)
    accuracy_graph = tf.reduce_mean(tf.cast(tf.equal(Y_predicted, tf.cast(Ytest, tf.float32)), tf.float32))
    return accuracy_graph


X_np, Y_np = inputs()  # Get the data samples
init_op = tf.global_variables_initializer()

# Execution: Training and Evaluation of the model
with tf.Session() as sess:
    sess.run(init_op)
    num_epochs = 55
    num_examples = X_np.shape[0] - batch_size + 1
    total_loss = loss(X, Y)  # Define the loss Graph
    train_op = train(total_loss)  # Define the training Graph
    perm_indices = np.arange(num_examples)
    for epoch in range(num_epochs):
        epoch_loss = 0
        np.random.shuffle(perm_indices)

        for i in range(num_examples - batch_size+1): # Sliding window of length = batch_size and shift = 1
            X_batch = X_np[perm_indices[i:i+batch_size], :]
            Y_batch = Y_np[perm_indices[i:i+batch_size], :]

            feed_dict = {X: X_batch, Y: Y_batch}
            batch_loss, _ = sess.run([total_loss, train_op], feed_dict)  # Fill the parenthesis
            # print('batch_loss = ', batch_loss)
            epoch_loss += batch_loss

        epoch_loss /= num_examples
        print('epoch:', epoch, '  epoch_loss = ', epoch_loss)

    # Start the Evaluation based on the trained model
    Xtest = tf.placeholder(shape=(None, num_features), dtype=tf.float32)  # Placeholder for one input vector
    Ytest = tf.placeholder(shape=(None, ), dtype=tf.int32)

    Ytest_inference, Ytest_predicted = inference(Xtest)  # Define the graphs for the inference and prediction
    accuracy = evaluate(Xtest, Ytest)  # Accuracy Graph
    
    # Predict the test sample [45, 85]
    test_sample = np.array([[45, 85]], dtype=np.float32)
    # Normalize the test sample
    test_sample = normalize(test_sample)

    feed_dict_test = {X: test_sample}
    print('\nPredicting the probabilities of sample [45, 85]')
    Ytest_inference, Ytest_predicted = inference(test_sample)
    print('\nBinary Prediction = ', Ytest_predicted.eval(), ' --- Prediction Probability = ', Ytest_inference.eval())

    # Predict the accuracy of the training samples (Cheating)
    feed_dict_test = {X: test_sample, Y: Ytest_predicted}
    accuracy_np = evaluate(X_np, Y_np)

    print('\nAccuracy of Training Samples = ', accuracy_np.eval())
