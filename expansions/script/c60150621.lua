--天夜 聚能冲击·以太之力
function c60150621.initial_effect(c)
	c:SetUniqueOnField(1,0,60150621)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c60150621.ffilter,aux.FilterBoolFunction(c60150621.ffilter2),false)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c60150621.splimit)
	c:RegisterEffect(e2)
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150621,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	--e3:SetCost(c60150621.mvcost)
	e3:SetTarget(c60150621.mvtg)
	e3:SetOperation(c60150621.seqop)
	c:RegisterEffect(e3)
	
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetValue(c60150621.disval)
	c:RegisterEffect(e4)
end
function c60150621.ffilter(c)
	return c:IsSetCard(0x5b21) and c:IsType(TYPE_MONSTER)
end
function c60150621.ffilter2(c)
	return (c:IsSetCard(0x3b21) and c:IsAttribute(ATTRIBUTE_LIGHT)) or c:IsHasEffect(60150643)
end
function c60150621.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150621.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c60150621.mvcostf(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c60150621.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60150621.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c60150621.mvcostf)
	e5:SetReset(RESET_PHASE+RESET_CHAIN)
	e:GetHandler():RegisterEffect(e5,true)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,s)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	if c:GetSequence()==nseq and Duel.SelectYesNo(tp,aux.Stringid(60150621,1)) then
		local cg=c:GetColumnGroup()
		local g=Duel.GetMatchingGroup(c60150621.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
		local g2=Duel.GetMatchingGroup(c60150621.thfilter2,tp,0,LOCATION_ONFIELD,nil,e,tp)
		Duel.BreakEffect()
		Duel.Destroy(g,REASON_EFFECT)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end
function c60150621.thfilter(c,g)
	return g:IsContains(c)
end
function c60150621.thfilter2(c,e,tp)
	local se=e:GetHandler():GetSequence() 
	if  se ==5 then
		se=1
	elseif se==6 then
		se=3
	end
	local seq=c:GetSequence()
	if  seq ==5 then
		seq=1
	elseif seq==6 then
		seq=3
	end
	if c:IsControler(1-tp) then 
		seq=math.abs(seq-4)
	end
	return math.abs(se-seq)==1--g:IsContains(c)
end
function c60150621.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c60150621.thfilter,tp,0,LOCATION_ONFIELD,1,nil,cg) end
	local g=Duel.GetMatchingGroup(c60150621.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60150621.cfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150621.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckOrExtraAsCost()
end
function c60150621.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0
	and Duel.IsExistingMatchingCard(c60150621.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c60150621.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		local g2=g:Filter(c60150621.gfilter,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150618,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150618,1))
			local sg=g2:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoExtraP(sg,nil,REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150642,2))
			local sg=g:Select(tp,1,1,nil)
			local tc2=sg:GetFirst()
			while tc2 do
				if not tc2:IsFaceup() then Duel.ConfirmCards(1-tp,tc2) end
				tc2=sg:GetNext()
			end
			Duel.SendtoDeck(sg,nil,2,REASON_COST)
		end
	end
end
function c60150621.desfilter2(c,s,tp)
	local seq=c:GetSequence()
	return math.abs(seq-s)==1 and c:IsControler(tp)
end
function c60150621.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	local g=Duel.GetMatchingGroup(c60150621.thfilter,tp,0,LOCATION_ONFIELD,nil,cg)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local g2=Duel.GetMatchingGroup(c60150621.thfilter2,tp,0,LOCATION_ONFIELD,nil,e,tp)
		Duel.BreakEffect()
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
	end
end
function c60150621.disval(e)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD,0)
end