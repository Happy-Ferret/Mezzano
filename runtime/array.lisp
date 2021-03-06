;;;; Copyright (c) 2011-2016 Henry Harrington <henry.harrington@gmail.com>
;;;; This code is licensed under the MIT license.

;;;; Low-level support functions for arrays.

(in-package :mezzano.runtime)

(defun sys.int::simple-character-array-p (object)
  (sys.int::%object-of-type-p object sys.int::+object-tag-simple-string+))

(defun %%simple-1d-array-p (object)
  (<= (sys.int::%object-tag object) sys.int::+last-simple-1d-array-object-tag+))

(declaim (inline sys.int::%simple-1d-array-p))
(defun sys.int::%simple-1d-array-p (object)
  (and (sys.int::%value-has-tag-p object sys.int::+tag-object+)
       (%%simple-1d-array-p object)))

(declaim (inline simple-vector-p))
(defun simple-vector-p (object)
  (sys.int::%object-of-type-p object sys.int::+object-tag-array-t+))

(declaim (inline sys.int::character-array-p))
(defun sys.int::character-array-p (object)
  (or (sys.int::%object-of-type-p object sys.int::+object-tag-simple-string+)
      (sys.int::%object-of-type-p object sys.int::+object-tag-string+)))

(defun %%arrayp (object)
  (<= (sys.int::%object-tag object) sys.int::+last-complex-array-object-tag+))

(declaim (inline arrayp))
(defun arrayp (object)
  (and (sys.int::%value-has-tag-p object sys.int::+tag-object+)
       (%%arrayp object)))

(defun %%complex-array-p (object)
  (<= sys.int::+first-complex-array-object-tag+
      (sys.int::%object-tag object)
      sys.int::+last-complex-array-object-tag+))

(declaim (inline sys.int::complex-array-p))
(defun sys.int::complex-array-p (object)
  (and (sys.int::%value-has-tag-p object sys.int::+tag-object+)
       (%%complex-array-p object)))

;;; Access to complex array slots.

(defun sys.int::%complex-array-storage (complex-array)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (sys.int::%object-ref-t complex-array sys.int::+complex-array-storage+))

(defun (setf sys.int::%complex-array-storage) (value complex-array)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (setf (sys.int::%object-ref-t complex-array sys.int::+complex-array-storage+) value))

(defun sys.int::%complex-array-fill-pointer (complex-array)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (sys.int::%object-ref-t complex-array sys.int::+complex-array-fill-pointer+))

(defun (setf sys.int::%complex-array-fill-pointer) (value complex-array)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (setf (sys.int::%object-ref-t complex-array sys.int::+complex-array-fill-pointer+) value))

(defun sys.int::%complex-array-info (complex-array)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (sys.int::%object-ref-t complex-array sys.int::+complex-array-info+))

(defun (setf sys.int::%complex-array-info) (value complex-array)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (setf (sys.int::%object-ref-t complex-array sys.int::+complex-array-info+) value))

(defun sys.int::%complex-array-dimension (complex-array axis)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (sys.int::%bounds-check complex-array axis)
  (sys.int::%object-ref-t complex-array (+ sys.int::+complex-array-axis-0+ axis)))

(defun (setf sys.int::%complex-array-dimension) (value complex-array axis)
  (when (not (sys.int::complex-array-p complex-array))
    (sys.int::raise-type-error complex-array '(and array
                                               (not (simple-array * (*))))))
  (sys.int::%bounds-check complex-array axis)
  (setf (sys.int::%object-ref-t complex-array (+ sys.int::+complex-array-axis-0+ axis)) value))

;;; Simple vectors.

(declaim (inline svref (setf svref) sys.int::simple-vector-length))

(defun svref (simple-vector index)
  (sys.int::%type-check simple-vector sys.int::+object-tag-array-t+ 'simple-vector)
  (sys.int::%bounds-check simple-vector index)
  (sys.int::%object-ref-t simple-vector index))

(defun (setf svref) (value simple-vector index)
  (sys.int::%type-check simple-vector sys.int::+object-tag-array-t+ 'simple-vector)
  (sys.int::%bounds-check simple-vector index)
  (setf (sys.int::%object-ref-t simple-vector index) value))

(defun (sys.int::cas svref) (old new simple-vector index)
  (sys.int::%type-check simple-vector sys.int::+object-tag-array-t+ 'simple-vector)
  (sys.int::%bounds-check simple-vector index)
  (multiple-value-bind (successp actual-value)
      (sys.int::%cas-object simple-vector index old new)
    (declare (ignore successp))
    actual-value))

(defun sys.int::simple-vector-length (simple-vector)
  (sys.int::%type-check simple-vector sys.int::+object-tag-array-t+ 'simple-vector)
  (sys.int::%object-header-data simple-vector))
