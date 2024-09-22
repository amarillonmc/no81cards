--植物娘·大蒜
function c65830040.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65830040,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c65830040.destg)
	e1:SetOperation(c65830040.desop)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(c65830040.atlimit)
	c:RegisterEffect(e2)
end


function c65830040.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function c65830040.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) end
end


function c65830040.atlimit(e,c)
	return c~=e:GetHandler()
end