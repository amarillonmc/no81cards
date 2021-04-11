--幻想曲T致命旋律 霜寒公主
function c60150918.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150918,6))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynCondition(c60150918.tfilter,aux.NonTuner(c60150918.tfilter),1,99))
	e1:SetTarget(aux.SynTarget(c60150918.tfilter,aux.NonTuner(c60150918.tfilter),1,99))
	e1:SetOperation(aux.SynOperation(c60150918.tfilter,aux.NonTuner(c60150918.tfilter),1,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150918,7))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c60150918.spcon2)
	e2:SetOperation(c60150918.spop2)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60150918,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e4:SetCondition(c60150918.descon)
	e4:SetTarget(c60150918.tgtg)
	e4:SetOperation(c60150918.tgop)
	c:RegisterEffect(e4)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetRange(LOCATION_MZONE)
	--[[e1:SetCondition(c60150918.condition)
	e1:SetTarget(c60150918.target)]]
	e1:SetOperation(c60150918.activate)
	c:RegisterEffect(e1)
	--spsummon2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60150918,9))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c60150918.spcon)
	e5:SetTarget(c60150918.sptg)
	e5:SetOperation(c60150918.spop)
	c:RegisterEffect(e5)
end
function c60150918.tfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c60150918.sprfilter1(c,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsType(TYPE_TOKEN) and c:IsSetCard(0x6b23) and c:IsCanBeSynchroMaterial()
		and Duel.IsExistingMatchingCard(c60150918.sprfilter2,tp,LOCATION_MZONE,0,1,nil,lv)
end
function c60150918.sprfilter2(c,lv)
	return c:IsFaceup() and c:GetLevel()~=lv and c:GetLevel()+lv==8 and c:IsType(TYPE_TOKEN)
	and c:IsSetCard(0x6b23) and c:IsCanBeSynchroMaterial()
end
function c60150918.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c60150918.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c60150918.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c60150918.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=Duel.SelectMatchingCard(tp,c60150918.sprfilter2,tp,LOCATION_MZONE,0,1,1,nil,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end
function c60150918.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c60150918.tgfilter(c)
	return c:IsSetCard(0x6b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c60150918.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150918.tgfilter,tp,0,LOCATION_DECK,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c60150918.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(60150918,0)) then
		local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
		Duel.ConfirmCards(tp,cg)
		local g=Duel.SelectMatchingCard(tp,c60150918.tgfilter,tp,0,LOCATION_DECK,1,2,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			local tc=g:GetFirst()
			local c=e:GetHandler()
			while tc do
			if tc:GetLevel()==2 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(60150918,1))
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e2:SetTargetRange(0,1)
				e2:SetReset(RESET_EVENT+0x1de0000)
				e2:SetTarget(c60150918.splimit2)
				c:RegisterEffect(e2)
			end
			if tc:GetLevel()==3 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(60150918,2))
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e2:SetTargetRange(0,1)
				e2:SetReset(RESET_EVENT+0x1de0000)
				e2:SetTarget(c60150918.splimit3)
				c:RegisterEffect(e2)	
			end
			if tc:GetLevel()==4 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(60150918,3))
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e2:SetTargetRange(0,1)
				e2:SetReset(RESET_EVENT+0x1de0000)
				e2:SetTarget(c60150918.splimit4)
				c:RegisterEffect(e2)			
			end
			if tc:GetLevel()==5 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(60150918,4))
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e2:SetTargetRange(0,1)
				e2:SetReset(RESET_EVENT+0x1de0000)
				e2:SetTarget(c60150918.splimit5)
				c:RegisterEffect(e2)			
			end
			if tc:GetLevel()==6 then
				local e2=Effect.CreateEffect(c)
				e2:SetDescription(aux.Stringid(60150918,5))
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e2:SetTargetRange(0,1)
				e2:SetReset(RESET_EVENT+0x1de0000)
				e2:SetTarget(c60150918.splimit6)
				c:RegisterEffect(e2)
			end
			tc=g:GetNext()
			end
		end
	end
end
function c60150918.splimit2(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c60150918.splimit3(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60150918.splimit4(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c60150918.splimit5(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c60150918.splimit6(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
--[[function c60150918.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local c=e:GetHandler()
	return (loc==LOCATION_HAND or loc==LOCATION_GRAVE 
	or loc==LOCATION_DECK or loc==LOCATION_REMOVED 
	or loc==LOCATION_EXTRA or loc==LOCATION_OVERLAY) 
	and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
	and c:IsSetCard(0x6b23)
end
function c60150918.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60150918.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end]]
function c60150918.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if re:IsActiveType(TYPE_MONSTER) and (loc==LOCATION_HAND or loc==LOCATION_GRAVE 
	or loc==LOCATION_DECK or loc==LOCATION_REMOVED 
	or loc==LOCATION_EXTRA or loc==LOCATION_OVERLAY)
		and not re:GetHandler():IsSetCard(0x6b23) then
		Duel.NegateEffect(ev)
	end
end
function c60150918.spcon(e,tp,eg,ep,ev,re,r,rp)
	
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
		and c:GetReasonPlayer()==1-tp
end
function c60150918.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6b23) and c:IsFaceup()
end
function c60150918.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c60150918.spfilter,tp,0,LOCATION_DECK,1,nil) end
end
function c60150918.spop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	Duel.ConfirmCards(tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c60150918.spfilter,tp,0,LOCATION_DECK,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(1-tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(1-tp,1)
		if Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(tp,aux.Stringid(60150918,8)) then
			Duel.BreakEffect()
			Duel.Draw(1-tp,1,REASON_EFFECT)
		end
	end
end