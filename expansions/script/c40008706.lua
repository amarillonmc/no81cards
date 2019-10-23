--炼狱骑士团 残酷指挥官
if not pcall(function() require("expansions/script/c40008677") end) then require("script/c40008677") end
function c40008706.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c40008706.lcheck)
	c:EnableReviveLimit()
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008706,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40008706)
	e2:SetTarget(c40008706.seqtg)
	e2:SetOperation(c40008706.seqop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40008706,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,40008707)
	e3:SetCost(rsik.cost())
	e3:SetTarget(c40008706.thtg)
	e3:SetOperation(c40008706.spop)
	c:RegisterEffect(e3)	  
end
function c40008706.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_DRAGON)
end
function c40008706.seqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c40008706.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c40008706.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c40008706.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40008706,2))
	Duel.SelectTarget(tp,c40008706.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c40008706.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(tc,nseq)~=0 then
		--Duel.BreakEffect()
		local atk=tc:GetAttack()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
	end
	end
end
function c40008706.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40008706.cfilter(c)
	return c:IsSetCard(0xf14) 
end
function c40008706.thfilter(c,lv)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40008706.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local g=Duel.GetMatchingGroup(c40008706.cfilter,tp,LOCATION_REMOVED,0,nil)
		local ct=g:GetClassCount(Card.GetCode)
		return Duel.IsExistingMatchingCard(c40008706.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40008706.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ct=Duel.GetMatchingGroupCount(c40008706.cfilter,tp,LOCATION_REMOVED,0,nil)
	local g=Duel.SelectMatchingCard(tp,c40008706.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ct)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

