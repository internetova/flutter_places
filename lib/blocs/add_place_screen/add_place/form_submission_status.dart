/// статус формы
abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

/// инициализация
class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

/// отправляется
class FormSubmitting extends FormSubmissionStatus {}

/// отправлено успешно
class SubmissionSuccess extends FormSubmissionStatus {}


/// неудача
class SubmissionFailed extends FormSubmissionStatus {
  final Exception exception;

  SubmissionFailed(this.exception);
}