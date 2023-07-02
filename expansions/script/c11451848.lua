--四色一心
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.getlvrklk(c)
	return math.max(c:GetLevel(),c:GetRank(),c:GetLink())
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetAttribute)==4 and g:GetClassCount(cm.getlvrklk)==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if chk==0 then return #g>3 and g:CheckSubGroup(cm.fselect,4,4) end
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if not (#g>3 and g:CheckSubGroup(cm.fselect,4,4)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local lg=g:SelectSubGroup(tp,cm.fselect,false,4,4)
	Duel.ConfirmCards(1-tp,lg)
	local cg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local hg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_HAND,nil)
	local b1=#cg>0
	local b2=#sg>0
	local b3=true
	local b4=#hg>1
	local off=1
	local ops={} 
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=cg:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			g:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif opval[op]==3 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATTRIBUTE)
		local attr=Duel.AnnounceAttribute(1-tp,1,ATTRIBUTE_ALL)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(0,1)
		e1:SetLabel(attr)
		e1:SetCondition(cm.actcon)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetLabel(attr)
		e2:SetOperation(cm.aclimit1)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		e1:SetLabelObject(e2)
	elseif opval[op]==4 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELF)
		local g=hg:Select(1-tp,1,1,nil)
		Duel.HintSelection(g)
		hg:Sub(g)
		for tc in aux.Next(hg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,4))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			tc:RegisterEffect(e3)
		end
	end
end
function cm.actcon(e)
	return e:GetLabelObject():GetValue()~=0
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(e:GetLabel())
end
function cm.ofilter(c,attr)
	return not c:IsAttribute(attr)
end
function cm.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	if ep~=tp and eg:IsExists(cm.ofilter,1,nil,e:GetLabel()) then
		e:SetValue(1)
	end
end