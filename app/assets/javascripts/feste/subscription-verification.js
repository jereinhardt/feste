subscriptionVerification = (function () {
  return function () {
    var $form = document.getElementById("edit-subscriptions-form");
    var $modal = document.getElementById("confirmation-modal");

    $form.addEventListener("submit", handleMainFormSubmission);

    function handleMainFormSubmission(event) {
      event.preventDefault();
      openModal($modal);
    }

    function openModal($modalContainer) {
      $modalContainer.classList.remove("hidden");
      bindModalEvents($modalContainer);
    }

    function closeModal($modalContainer) {
      $modalContainer.className += " hidden";
      unbindModalEvents($modalContainer);
    }

    function bindModalEvents($modalContainer) {
      var $closeButtons = $modalContainer.querySelectorAll("[data-js-modal-close]");
      for (var i = 0; i < $closeButtons.length; i ++) {
        var $button = $closeButtons[i];
        $button.addEventListener("click", function(event) {
          if ( event.target == event.currentTarget ) {
            event.preventDefault();
            closeModal($modalContainer);  
          }        
        });
      }

      var $confirmForm = document.getElementById("cancel-subscription-form");
      $confirmForm.addEventListener("submit", handleConfirmFormSubmission);
    }

    function unbindModalEvents($modalContainer) {
      var $closeButtons = $modalContainer.querySelectorAll("[data-js-modal-close]");
      for (var i = 0; i < $closeButtons.length; i ++) {
        var $button = $closeButtons[i];
        $button.removeEventListener("click", function(event) {
          if ( event.target == event.currentTarget ) {
            event.preventDefault();
            closeModal($modalContainer);  
          }        
        });
      }

      var $confirmForm = document.getElementById("cancel-subscription-form");
      $confirmForm.removeEventListener("submit", handleConfirmFormSubmission);
    }

    function handleConfirmFormSubmission(event) {
      event.preventDefault();
      var $form = event.target;
      var $input = document.getElementById("email-confirmation-input");
      var $required = $form.querySelectorAll("[data-js-required]")[0];
      var $errorMessage = $required.querySelectorAll("[data-js-error]")[0];
      var val = $required.querySelectorAll("input")[0].value;
      var email = document.getElementById("subscriber-email").value
      $errorMessage.className += " hidden";
      if (!val || val != email) {
        $errorMessage.classList.remove("hidden");
      } else {
        var $mainForm = document.getElementById("edit-subscriptions-form");
        $mainForm.submit();
      }
    }
  }   
})();