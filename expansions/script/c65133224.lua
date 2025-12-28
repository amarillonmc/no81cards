--幻叙滑翔者 诺林·莱德
local s,id,o=GetID()
function s.initial_effect(c)
	--Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Def up and Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.reccon)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	--Banish until summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_ADJUST)
	ex:SetRange(LOCATION_MZONE)
	ex:SetCondition(s.chcon)
	ex:SetOperation(s.chop)
	c:RegisterEffect(ex)
end
function s.cfilter(c)
	return c:IsSummonLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.rcfilter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and not c:IsPublic()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.ShuffleHand(tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
	end
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=0
	for tc in aux.Next(eg) do
		local atk=tc:GetAttack()
		if atk<0 then atk=0 end
		val=val+atk
	end
	if val>0 and c:IsRelateToChain() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
	Duel.Recover(tp,500,REASON_EFFECT)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsContains(c) and c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SetLP(tp,Duel.GetLP(tp)-500)
	if c:IsRelateToChain() and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabelObject(c)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	Duel.ReturnToField(c)
	e:Reset()
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=Duel.GetLP(1-tp)*2
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOriginalCode()~=id then return end
	c:SetEntityCode(65133225,true)
	c:ReplaceEffect(65133225,0,1)
	local def=c:GetDefense()
	Duel.Hint(HINT_CARD,0,65133225)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(def)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(def)
	c:RegisterEffect(e2)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+id,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end