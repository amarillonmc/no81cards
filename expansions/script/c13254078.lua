--飞球之时空裂隙
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.pctg)
	e3:SetOperation(s.pcop)
	c:RegisterEffect(e3)
	elements={{"tama_elements",{{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_CHAOS,1}}}}
	s[c]=elements
	
end
function s.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_ORDER,2},{TAMA_ELEMENT_CHAOS,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function s.rtfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsFaceup()
end
function s.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local t1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,nil)
	local t2=Duel.IsExistingMatchingCard(s.rtfilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return t1 or t2 end
	local op=0
	if t1 or t2 then
		local m1={}
		local n1={}
		local ct=1
		if t1 then m1[ct]=aux.Stringid(id,1) n1[ct]=1 ct=ct+1 end
		if t2 then m1[ct]=aux.Stringid(id,2) n1[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m1))
		op=n1[sp+1]
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND)
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
	end
end
function s.lmfilter(c)
	return #(tama.tamas_getElements(c))~=0
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			local og=Duel.GetOperatedGroup()
			local g1=og:Filter(s.lmfilter,nil)
			local tc=g1:GetFirst()
			while tc do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_ACTIVATE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetCondition(s.con)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_CANNOT_SSET)
				tc:RegisterEffect(e3)
				local e4=e2:Clone()
				e4:SetCode(EFFECT_CANNOT_MSET)
				tc:RegisterEffect(e4)
				local e5=e2:Clone()
				e5:SetCode(EFFECT_CANNOT_SUMMON)
				tc:RegisterEffect(e5)
				local e6=e2:Clone()
				e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				tc:RegisterEffect(e6)
				tc=g1:GetNext()
			end
		end
	elseif e:GetLabel()==2 then
		local tg=Duel.GetMatchingGroup(s.rtfilter,tp,LOCATION_REMOVED,0,nil)
		local ct=tg:GetCount()
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
			local sel=tg:Select(tp,1,ct,nil)
			Duel.SendtoGrave(sel,REASON_EFFECT+REASON_RETURN)
		end
	end
end
function s.con(e)
	local c=e:GetLabelObject()
	return c:GetFlagEffectLabel(id)>0
end
