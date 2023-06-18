--古代魔 综合征玛琉斯
local m=82209115
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,1,2)  
	c:EnableReviveLimit()
	--eat
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.eatcon)
	e1:SetTarget(cm.eattg) 
	e1:SetOperation(cm.eatop)  
	c:RegisterEffect(e1)
	--spsummon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,5))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetCountLimit(1)  
	e2:SetCost(cm.spcost)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2) 
	--eat2
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,6))  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_BATTLE_START)  
	e3:SetCountLimit(1)
	e3:SetTarget(cm.eattg2)  
	e3:SetOperation(cm.eatop2)  
	c:RegisterEffect(e3) 
end

--effect 1
function cm.eatcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)  
end  
function cm.eatfilter(c)  
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanOverlay()  
end  
function cm.eattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.eatfilter(chkc) end  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)  
		and Duel.IsExistingTarget(cm.eatfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
	Duel.SelectTarget(tp,cm.eatfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
end  
function cm.eatop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then  
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc))  
	end  
end  

--effect 2
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local i=1
	local canActivate=false
	if chk==0 then
		while i<5 do
			if e:GetHandler():CheckRemoveOverlayCard(tp,i,REASON_COST) and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,i) then canActivate=true end
			i=i+1
		end
		return canActivate
	end
		
	local ableOption={}
	local ableLevel={}
	i=1
	while i<5 do
		if e:GetHandler():CheckRemoveOverlayCard(tp,i,REASON_COST) and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,i) then
			table.insert(ableOption,aux.Stringid(m,i))
			table.insert(ableLevel,i)
		end
		i=i+1
	end
	local level=ableLevel[Duel.SelectOption(tp,table.unpack(ableOption))+1]
	e:SetLabel(level)
	e:GetHandler():RemoveOverlayCard(tp,level,level,REASON_COST)  
end  
function cm.spfilter(c,e,tp,count)  
	return c:IsLevel(count) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp,e:GetLabel()) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetLabel())  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)  
		e1:SetDescription(aux.Stringid(m,7))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)  
		e1:SetValue(1)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1) 
		Duel.SpecialSummonComplete()
	end
end

--effect 3
function cm.eattg2(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	local tc=c:GetBattleTarget()  
	if chk==0 then return tc and c:IsType(TYPE_XYZ) and tc:IsCanOverlay() and tc:GetControler()==1-tp end  
end  
function cm.eatop2(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=c:GetBattleTarget()  
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToBattle() and tc:GetControler()==1-tp and not tc:IsImmuneToEffect(e) then  
		local og=tc:GetOverlayGroup()  
		if og:GetCount()>0 then  
			Duel.SendtoGrave(og,REASON_RULE)  
		end  
		Duel.Overlay(c,Group.FromCards(tc))  
	end  
end  