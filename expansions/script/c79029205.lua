--镜像衍生物-血色乐章
function c79029205.initial_effect(c)
   c:EnableCounterPermit(0x18)
   --counter
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
   e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   e1:SetOperation(c79029205.cop)
   c:RegisterEffect(e1)
   --atk
   local e2=Effect.CreateEffect(c)
   e2:SetType(EFFECT_TYPE_SINGLE)
   e2:SetCode(EFFECT_UPDATE_ATTACK)
   e2:SetValue(c79029205.val)
   c:RegisterEffect(e2)
   --remove COUNTER
   local e3=Effect.CreateEffect(c)
   e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
   e3:SetCode(EVENT_BATTLE_DAMAGE)
   e3:SetCategory(CATEGORY_COUNTER)
   e3:SetOperation(c79029205.rcop)
   c:RegisterEffect(e3)
end
function c79029205.val(e,c)
   return e:GetHandler():GetCounter(0x18)*500 
end
function c79029205.cop(e,tp,eg,ep,ev,re,r,rp)
   e:GetHandler():AddCounter(0x18,8)
end
function c79029205.rcop(e,tp,eg,ep,ev,re,r,rp)
   e:GetHandler():RemoveCounter(tp,0x18,1,REASON_EFFECT)
end

