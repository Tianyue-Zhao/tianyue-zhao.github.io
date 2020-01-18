---
comments: true
---
[Work In Progress]
## The concept of traversal
In an age of rapid development of machine learning techniques, it is well-known that Neural Networks can perform complex classification tasks with great accuracy, and have been put into commercial use in many applications. However, it is important to know that accuracy is not the only goal we can shoot for - humans can not only make classifications according to concepts, but also manipulate and apply concepts.

**Put into context, this uncovers another potential goal in machine learning classifiers - the ability to traverse between classes.** As an example, consider a Neural Network that discerns the type of material an object is made of. An image of a plastic cup is given to this Neural Network, and it correctly recognizes the material as plastic - but what if we wanted to know what the cup would look like if, while preserving shape and color, it was made of metal instead? In principle, we could adjust the pixels in the image according to the calculated gradients, just enough to make the Neural Network classify cup as "metal." At this point, the image would theoretically have changed enough to actually appear as a realistic metal cup. In practice, doing so would result in an image that is classified as "metal" by the Network, yet looks nothing like metal to the human eye. However, numerous changes to the architecture of Networks could improve the results.

In this post, we experiment to explore how manipulable a modern MNIST Neural Network is. Although traversing on an MNIST network does not satisfy any real-life applications, the conclusion should generalize well to other networks in which traversal would be beneficial.

## Recent advances
Several years ago, the concept of traversal would hardly be worth trying due to the existence of adversarial examples. In the context of computer vision classifiers, adversarial examples LINK HERE are images added with a slight but carefully chosen layer of noise, and are barely different from the original image to the human eye. However, the slight noise dramatically changes the decision of the network, and could cause the Network confidently declare the image "made of metal," when the image had not changed much at all.

**This indicates that the network is only accurate in very narrow "zones" covered by the training data.** In other words, the training process only penalizes incorrect classifications on existing examples, and therefore the Network performs well on completely realistic images, but any deviation from the training data would cause the Network to become meaningless.

More recently, adversarial training LINK HERE techniques have been developed, and allow Networks to become "robust" to adversarial examples. To change the classification of a robust Network, the example would necessarily have to be heavily modified. This is mainly a security improvement, as important ML systems could no longer be easily spoofed, but clearly implies that robust Networks could perform better when traversed.

## Method
To conduct adversarial training, we generate adversarial examples, and then train the network on the adversarial examples. As the image still has to adhere to its label, we can only manipulate the image to a certain extent, which we limit with a L2 norm. When we can no longer generate an image that stays within the L2 norm and deviates from the label, we declare the Network to be robust.

The process of generating an adversarial example and traversal is nearly the same. Both involve using back-propagation to calculate the gradients of the Network's output with regards to the input image's pixels, and then manipulating the image according to these gradients, to make the Network's output change in a certain direction with each change.

With adversarial training, we still need the image to adhere to the original label, and so we must limit by how much we can manipulate the image. In this post, this is done with an L2 norm, along with Projected Gradient Descent LINK HERE. In short, PGD conducts a step of gradient descent without regard to the L2 constraint, and then projects the resulting example to the closest example that does satisfy the constraint. When conducting traversal, no such constraint is necessary.

## Results
**In large, the robust network displayed much better performance, and traversal is nearly realistic in some examples. However, performance is inconsistent, and most examples still suffer from large amounts of noise. There is still a long way to go.**

Video: L2 No. 13, 5 to 0    Non-adversarial No. 14, 5 to 0

As seen in the video above, the traversal process is indeed much more successful in the adversarially robust Neural Network. By frame 130, the traversal had removed the distinguishing features of the number 5, and produced a recognizeable 0, a notable success. The noise became more pronounced as the traversal continued to run, likely because the gradient lacks non-linear terms that allow it to actually converge at a certain point. In comparison, one could argue that the non-robust network produces a very rough 0 by frame 150, but the noise is much more pronounced and random, making the image unrealistic. It is then fair to conclude that adversarial training does have a positive effect on traversal performance, mainly in terms of taming the noise that often appears.

However, the general performance of the robust network is still inconsistent and unexceptional. The level of success heavily depends on factors such as the position of the target image in the frame, the type of digit starting from, and so on. For the videos below, the 2 to 0 transition on the left is able to completely eliminate the 2's distinguishing features, while the right video largely fails, likely due to the position of the digit.

Video: L2 No. 38    L2 No. 33

Traversal performance clearly has a long way to go, with changes in architecture and training method possibly bringing further improvements. For example, a certain shortcoming is how adversarial training produces the most effect in a small "radius": as the original label for each example must stay true, we can only perturb each image so much in adversarial training, and this would only produce the best effect in the initial stages of the traversal.

For further reference, several other random examples from the robust network are displayed below.

