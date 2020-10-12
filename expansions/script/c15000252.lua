local m=15000252
local cm=_G["c"..m]
cm.name="永寂之旅人：安德萝"
function cm.initial_effect(c)
	--XyzSummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetCountLimit(1,15000252)  
	e1:SetTarget(cm.tg)  
	e1:SetOperation(cm.op)  
	c:RegisterEffect(e1)
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e2)
	--link summon  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND)  
	e3:SetCountLimit(1,15010252)
	e3:SetCost(cm.cost)   
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)  
	e3:SetOperation(cm.operation)  
	c:RegisterEffect(e3)
	local e4=e3:Clone()  
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end
function cm.tgfilter1(c,e,tp)  
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0xf37) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter1(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	Duel.SelectTarget(tp,cm.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)  
		local sc=g:GetFirst()  
		if sc then   
			local mg=tc:GetOverlayGroup()  
			if mg:GetCount()>0 then  
				Duel.Overlay(sc,mg)  
			end
			sc:SetMaterial(Group.FromCards(tc))  
			Duel.Overlay(sc,Group.FromCards(tc))  
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)  
			sc:CompleteProcedure()  
		end  
	end  
end
function cm.tgfilter(c,tp,ec)  
	local mg=Group.FromCards(ec,c)  
	return c:IsFaceup() and Duel.IsExistingMatchingCard(cm.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg,tp) 
end  
function cm.lfilter(c,mg,tp)  
	return c:IsSetCard(0xf37) and c:IsLinkSummonable(mg,nil,2,2) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end 
function cm.filter(c)  
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.filter1(c)  
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xf37)
end 
function cm.filter2(c,ec,tc)  
	return c:IsFaceup() and ec:IsLinkSummonable(Group.FromCards(tc,c),nil,2,2) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(tc,c),ec)>0
end
function cm.filter3(c,tttc,ttttc)  
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xf37) and c:IsLinkSummonable(Group.FromCards(tttc,ttttc),nil,2,2) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(tttc,ttttc),c)>0
end
function cm.filter4(c,tttc,ttttc,ttc)  
	return c:IsCode(ttc:GetCode()) and c:IsType(TYPE_LINK) and c:IsSetCard(0xf37) and c:IsLinkSummonable(Group.FromCards(tttc,ttttc),nil,2,2) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(tttc,ttttc),c)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local ag=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if Duel.IsExistingTarget(cm.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,tc) then ag:AddCard(tc) end
		tc=g:GetNext()
	end
	return ag:GetCount()~=0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local tp=e:GetHandler():GetControler()
	if chkc then return false end  
	if chk==0 then return true end  
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,e:GetHandler())
	local ag=Group.CreateGroup()
	local g2=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_EXTRA,0,nil)
	local g3=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	local g4=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_MZONE,nil)
	local g5=Group.CreateGroup()
	local ttc=g2:GetFirst()
	while ttc do
		local tttc=g3:GetFirst()
		while tttc do
			local ttttc=g4:GetFirst()
			while ttttc do
				local g6=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_EXTRA,0,nil,tttc,ttttc)
				if g6:GetCount()~=0 then
					Group.Merge(g5,g6)
				end
				ttttc=g4:GetNext()
			end
			tttc=g3:GetNext()
		end
		ttc=g2:GetNext()
	end
	if g5:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sumg=Group.Select(g5,tp,1,1,nil)
	e:SetLabelObject(sumg:GetFirst())
	local ttc=sumg:GetFirst()
	while ttc do
		local tttc=g3:GetFirst()
		while tttc do
			local ttttc=g4:GetFirst()
			while ttttc do
				local g6=Duel.GetMatchingGroup(cm.filter4,tp,LOCATION_EXTRA,0,nil,tttc,ttttc,ttc)
				if g6:GetCount()~=0 then
					Group.RemoveCard(g,tttc)
				end
				ttttc=g4:GetNext()
			end
			tttc=g3:GetNext()
		end
		ttc=g2:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local bg1=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local bg2=Duel.SelectTarget(tp,cm.filter2,tp,0,LOCATION_MZONE,1,1,nil,sumg:GetFirst(),bg1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sumg,1,tp,LOCATION_EXTRA)  
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	local tc=e:GetLabelObject()  
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS) 
	local tc1=tg:GetFirst()
	local tc2=tg:GetNext()
	if not (tc1 and tc2 and tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) and tc1:IsFaceup() and tc2:IsFaceup() and tc1:IsLocation(LOCATION_MZONE) and tc2:IsLocation(LOCATION_MZONE)) then return end
	Duel.BreakEffect()
	Duel.LinkSummon(tp,tc,tg,nil,2,2)
end