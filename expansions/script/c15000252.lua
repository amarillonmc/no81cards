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
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)  
	e3:SetCountLimit(1,15000257)
	e3:SetCost(cm.cost)   
	e3:SetTarget(cm.target)  
	e3:SetOperation(cm.operation)  
	c:RegisterEffect(e3)
end
function cm.tgfilter1(c,e,tp)  
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end  
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0xaf37) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local tp=e:GetHandler():GetControler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tgfilter1(chkc,e,tp) end  
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end  
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
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)  
end
function cm.targetfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g,tp)
	return Duel.IsExistingMatchingCard(cm.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g) and g:IsExists(Card.IsControler,1,nil,tp) and g:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.lkfilter(c,g)
	return c:IsSetCard(0xaf37) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function cm.chkfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0xaf37) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local cg=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(cm.targetfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e)
		return g:CheckSubGroup(cm.fselect,2,2,tp)
	end
	local g=Duel.GetMatchingGroup(cm.targetfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local og=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tg=Duel.GetMatchingGroup(cm.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
	if og:GetCount()>0 and tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
	end
end