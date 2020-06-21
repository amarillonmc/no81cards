--镜像衍生物-暗夜魅影
function c79029204.initial_effect(c)
   --counter
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
   e1:SetCategory(CATEGORY_COUNTER)
   e1:SetCode(EVENT_SPSUMMON_SUCCESS)
   e1:SetOperation(c79029204.cop)
   c:RegisterEffect(e1)
   --destory replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c79029204.reptg)
	e3:SetOperation(c79029204.repop)
	c:RegisterEffect(e3)
   
end
function c79029204.cop(e,tp,eg,ep,ev,re,r,rp)
   e:GetHandler():AddCounter(0x1019,3)
end
function c79029204.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x1019)>=0 and Duel.IsPlayerCanDraw(tp,2) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),79029096)
end
function c79029204.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	e:GetHandler():RemoveCounter(tp,0x1019,1,REASON_EFFECT+REASON_REPLACE)
	Duel.Draw(tp,2,REASON_EFFECT+REASON_REPLACE)
end





