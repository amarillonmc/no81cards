--天龙座的领袖-DRA
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit() 
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.tgcon)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(s.tgcon2)
	c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3224))
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)

end
function s.refilter(c,e,tp)
	return c:IsSetCard(0x3224) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.refilter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel())
end
function s.refilter2(c,e,tp,lv)
	local ld=math.abs(c:GetLevel()-lv) 
	return c:IsSetCard(0x3224) and c:IsType(TYPE_MONSTER) and not c:IsLevel(lv) and c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(s.desfilter,tp,0,LOCATION_MZONE,1,nil,ld)   
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.desfilter(c,ld)
	return c:IsFaceup() and (c:IsLevelBelow(ld) or c:IsLinkBelow(ld) or c:IsRankBelow(ld) )
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(s.refilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.refilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,s.refilter2,tp,LOCATION_GRAVE,0,1,1,tc,e,tp,tc:GetLevel())
	g:Merge(g2)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local ld=math.abs(tc:GetLevel()-g2:GetFirst():GetLevel())  
	Duel.SetTargetParam(ld)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,ld)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,nil,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local ld=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local lv=math.floor(ld/2)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil,ld)
	local g1=g:Filter(s.desfilter,nil,lv)
	--local tc=g1:GetFirst()
   -- while tc do
		--Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		--g:RemoveCard(tc)
	   -- tc=g1:GetNext()
   -- end
	Duel.Remove(g1,POS_FACEDOWN,REASON_EFFECT)
	Duel.Destroy(g-g1,REASON_EFFECT)
end
--02
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11640015)
end
function s.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11640015) and Duel.GetFlagEffect(tp,11640015)<2
end
function s.cfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function s.cfilter2(c)
	return c:IsAbleToGrave() and c:IsLocation(LOCATION_HAND)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,c)
	local sc=g:GetFirst()
	local tg=Group.FromCards(c,sc)  
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)  
	e:SetLabelObject(sc) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if Duel.GetTurnPlayer()==1-tp  then
		Duel.RegisterFlagEffect(tp,11640015,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.ctfilter(c)
	return c:IsSetCard(0x3224) and c:IsFaceup()
end
function s.copyfilter(c)
	return c:IsSetCard(0x3224) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local ld=math.abs(c:GetLevel()-sc:GetLevel())   
	local mg=Group.FromCards(c,sc)
	local lv=1
	if ld>0 then
		lv=ld
	end
	local ct=Duel.GetMatchingGroup(s.ctfilter,tp,LOCATION_MZONE,0,nil):GetClassCount(Card.GetCode)
	if ld<=5 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct  and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.ConfirmDecktop(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if g:GetCount()>0 then
			local tg=g:Filter(Card.IsAbleToHand,nil)
			if tg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=tg:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		Duel.ShuffleDeck(tp)
		end
	elseif ld>5 and Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.copyfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		te:SetLabelObject(e:GetLabelObject())
		e:SetLabelObject(te) 
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	if Duel.IsPlayerAffectedByEffect(tp,11640016) and Duel.GetFlagEffect(tp,11640016)<2 and Duel.SelectYesNo(tp,aux.Stringid(11640015,0)) then
		Duel.Hint(HINT_CARD,0,11640015)
		Duel.RegisterFlagEffect(tp,11640016,RESET_PHASE+PHASE_END,0,1)
	else
		local tg=mg:FilterSelect(tp,s.cfilter2,1,1,nil):GetFirst()
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsNonAttribute,ATTRIBUTE_LIGHT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--
function s.atkfilter(c)
	return c:IsFaceup()
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	local gc=g:GetClassCount(Card.GetRace)
	return gc*200   
end

