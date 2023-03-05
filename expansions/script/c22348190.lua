--无 法 触 及 的 遥 远 之 地
local m=22348190
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348190,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(c22348190.extg)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TRUE)
	e2:SetValue(c22348190.val1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--atk/def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(aux.TRUE)
	e4:SetValue(c22348190.val2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e61=Effect.CreateEffect(c)
	e61:SetDescription(aux.Stringid(22348190,1))
	e61:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e61:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e61:SetCode(EVENT_SUMMON_SUCCESS)
	e61:SetRange(LOCATION_FZONE)
	e61:SetCountLimit(1,22348190)
	e61:SetTarget(c22348190.sptg)
	e61:SetOperation(c22348190.spop)
	c:RegisterEffect(e61)
	local e62=e61:Clone()
	e62:SetCondition(c22348190.spcon)
	e62:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e62)
	--SearchCard
	local e71=Effect.CreateEffect(c)
	e71:SetDescription(aux.Stringid(22348190,2))
	e71:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e71:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e71:SetCode(EVENT_SUMMON_SUCCESS)
	e71:SetRange(LOCATION_FZONE)
	e71:SetCountLimit(1,22349190)
	e71:SetTarget(c22348190.actg)
	e71:SetOperation(c22348190.acop)
	c:RegisterEffect(e71)
	local e72=e71:Clone()
	e72:SetCondition(c22348190.spcon)
	e72:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e72)
	--tograve
	local e81=Effect.CreateEffect(c)
	e81:SetDescription(aux.Stringid(22348190,3))
	e81:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e81:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e81:SetCode(EVENT_SUMMON_SUCCESS)
	e81:SetRange(LOCATION_FZONE)
	e81:SetCountLimit(1,22350190)
	e81:SetTarget(c22348190.tgtg)
	e81:SetOperation(c22348190.tgop)
	c:RegisterEffect(e81)
	local e82=e81:Clone()
	e82:SetCondition(c22348190.spcon)
	e82:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e82)
	--tograve
	local e91=Effect.CreateEffect(c)
	e91:SetDescription(aux.Stringid(22348190,4))
	e91:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e91:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e91:SetCode(EVENT_SUMMON_SUCCESS)
	e91:SetRange(LOCATION_FZONE)
	e91:SetCountLimit(1,22351190)
	e91:SetTarget(c22348190.cltg)
	e91:SetOperation(c22348190.clop)
	c:RegisterEffect(e91)
	local e92=e91:Clone()
	e92:SetCondition(c22348190.spcon)
	e92:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e92)
	
end
function c22348190.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c22348190.extg(e,c)
	return c:IsSetCard(0x706)
end
function c22348190.atkfilter1(c)
	local seq=c:GetSequence()
	return seq<1
end
function c22348190.atkfilter3(c)
	local seq=c:GetSequence()
	return seq<2
end
function c22348190.atkfilter5(c)
	local seq=c:GetSequence()
	return seq<3
end
function c22348190.atkfilter7(c)
	local seq=c:GetSequence()
	return seq<4
end
function c22348190.val1(e,c)
	local tp=e:GetHandler():GetControler()
	local seq=aux.MZoneSequence(c:GetSequence())
	if seq==1 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter1,tp,LOCATION_MZONE,0,nil)*-500
	elseif seq==2 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter3,tp,LOCATION_MZONE,0,nil)*-500
	elseif seq==3 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter5,tp,LOCATION_MZONE,0,nil)*-500
	elseif seq==4 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter7,tp,LOCATION_MZONE,0,nil)*-500
	end
end
function c22348190.val2(e,c)
	local tp=e:GetHandler():GetControler()
	local seq=aux.MZoneSequence(c:GetSequence())
	if seq==1 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter1,tp,0,LOCATION_MZONE,nil)*-500
	elseif seq==2 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter3,tp,0,LOCATION_MZONE,nil)*-500
	elseif seq==3 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter5,tp,0,LOCATION_MZONE,nil)*-500
	elseif seq==4 then
		  return Duel.GetMatchingGroupCount(c22348190.atkfilter7,tp,0,LOCATION_MZONE,nil)*-500
	end
end
function c22348190.spfilter1(c,e,tp)
	return c:IsSetCard(0x706) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348190.spfilter2(c)
	return c:IsSetCard(0x706) and c:IsAbleToHand()
end
function c22348190.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348190.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(22348190)==0 end
	e:GetHandler():RegisterFlagEffect(22348190,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c22348190.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348190.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c22348182.spfilter2,tp,LOCATION_MZONE,0,1,nil) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		   Duel.BreakEffect()
		   local tg=Duel.SelectMatchingCard(tp,c22348190.spfilter2,tp,LOCATION_MZONE,0,1,1,nil)
		   if tg:GetCount()>0 then
			   Duel.SendtoHand(tg,nil,REASON_EFFECT)
		   end
	end
end
function c22348190.acfilter1(c)
	return c:IsSetCard(0x706) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c22348190.acfilter2(c)
	return c:IsSetCard(0x706) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c22348190.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348190.acfilter1,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():GetFlagEffect(22348190)==0 end
	e:GetHandler():RegisterFlagEffect(22348190,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c22348190.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348190.acfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c22348190.acfilter2,tp,LOCATION_HAND,0,1,nil) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		   Duel.BreakEffect()
		   local tg=Duel.SelectMatchingCard(tp,c22348190.acfilter2,tp,LOCATION_HAND,0,1,1,nil)
		   if tg:GetCount()>0 then
			   Duel.SendtoGrave(tg,REASON_EFFECT)
		   end
	end
end
function c22348190.tgfilter1(c)
	return c:IsSetCard(0x706) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c22348190.tgfilter2(c)
	return c:IsSetCard(0x706) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c22348190.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348190.tgfilter1,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(22348190)==0 end
	e:GetHandler():RegisterFlagEffect(22348190,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c22348190.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348190.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c22348190.tgfilter2,tp,LOCATION_GRAVE,0,1,nil) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		   Duel.BreakEffect()
		   local tg=Duel.SelectMatchingCard(tp,c22348190.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		   if tg:GetCount()>0 then
			   Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		   end
	end
end
function c22348190.xyzfilter(c)
	return c:IsSetCard(0x706) and c:IsXyzSummonable(nil)
end
function c22348190.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348190.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():GetFlagEffect(22348190)==0 end
	e:GetHandler():RegisterFlagEffect(22348190,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22348190.clop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348190.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end













