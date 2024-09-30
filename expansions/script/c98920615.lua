--火山帝王
function c98920615.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920615,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(c98920615.spcon)
	e1:SetTarget(c98920615.sptg)
	e1:SetOperation(c98920615.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,98920615)
	e2:SetCondition(c98920615.negcon)
	e2:SetTarget(c98920615.target)
	e2:SetOperation(c98920615.operation)
	c:RegisterEffect(e2)
	--spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(c98920615.spcost)
	e3:SetOperation(c98920615.spcop)
	c:RegisterEffect(e3)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(98920615,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98920615.damcon)
	e2:SetTarget(c98920615.damtg)
	e2:SetOperation(c98920615.damop)
	c:RegisterEffect(e2)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98920615.fselect(g,tp)
	return Duel.GetMZoneCount(1-tp,g,tp)>0
end
function c98920615.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil,REASON_SPSUMMON)
	return rg:CheckSubGroup(c98920615.fselect,2,2,tp)
end
function c98920615.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0,LOCATION_MZONE,nil,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c98920615.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c98920615.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c98920615.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function c98920615.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98920615.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	for i=1,2 do
		local g=Duel.GetMatchingGroup(c98920615.rmfilter,p,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(p,aux.Stringid(98920615,4)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_REMOVE)
			local tg=g:Select(p,1,1,nil)
			Duel.SendtoHand(tg,p,REASON_EFFECT)
		else
			 Duel.Damage(p,1000,REASON_EFFECT)
		end
		p=1-p
	end
end
function c98920615.rmfilter(c)
	return c:IsSetCard(0x32) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920615) and c:IsAbleToHand()
end
function c98920615.spcost(e,c,tp)
	return Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0
end
function c98920615.spcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e2,tp)
end
function c98920615.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98920615.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c98920615.tgfilter(c)
	return c:IsSetCard(0x55,0x7b) and c:IsAbleToGrave()
end
function c98920615.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c98920615.tgfilter,tp,LOCATION_DECKs,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98920615,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	else 
		Duel.GetControl(e:GetHandler(),1-tp)
	end
end