--GUARDIAN 江坂
function c33700049.initial_effect(c)
	  --summon without tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33700049,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c33700049.ntcon)
	c:RegisterEffect(e1)
	 --remove
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(33700049,1))
	ea:SetCategory(CATEGORY_REMOVE+CATEGORY_COUNTER)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ea:SetCode(EVENT_BATTLE_START)
	ea:SetTarget(c33700049.rmtg)
	ea:SetOperation(c33700049.rmop)
	c:RegisterEffect(ea)
end
function c33700049.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetMZoneCount(c:GetControler())>0
		and Duel.GetCounter(c:GetControler(),LOCATION_ONFIELD,0,0x1021)>0
end
function c33700049.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) and tc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c33700049.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
	 local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	g:GetFirst():AddCounter(0x1021,1)
	end
end