--究极混合体
local m=30005503
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddMaterialCodeList(c,30005500,30005501,30005502)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,cm.fus1,cm.fus2,cm.fus3,cm.fus4,cm.fus5)
	--Effect 1
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1)
	e51:SetTarget(cm.nmtg)
	e51:SetOperation(cm.nmop)
	c:RegisterEffect(e51)  
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.uthcon)
	e1:SetTarget(cm.uthtg)
	e1:SetOperation(cm.uthop)
	c:RegisterEffect(e1) 
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_MATERIAL_CHECK)
	e12:SetValue(cm.valcheck)
	e12:SetLabelObject(e1)
	c:RegisterEffect(e12)
	--Effect 3 
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	--e2:SetCountLimit(1,m+m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)   
	--e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
--fusion material
function cm.fus1(c)
	return c:IsFusionCode(30005500)
end
function cm.fus2(c)
	return c:IsFusionCode(30005501)
end
function cm.fus3(c)
	return c:IsFusionCode(30005502)
end
function cm.fus4(c)
	return c:IsFusionType(TYPE_FUSION)
end
function cm.fus5(c)
	return c:IsFusionType(TYPE_EFFECT)
end
--Effect 1
function cm.nf(c)
	if c:GetType()&TYPE_MONSTER==0 then return false end
	return Duel.IsExistingMatchingCard(cm.nf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function cm.nf1(c,ec)
	return c:IsFaceup() and not c:IsCode(ec:GetCode())
end
function cm.nmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.nf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function cm.nmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.nf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	local name=tc:GetCode()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local tcc=Duel.SelectMatchingCard(tp,cm.nf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc):GetFirst()
		if tcc==nil or tcc:IsFacedown() or tcc:IsImmuneToEffect(e) then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(name)
		tcc:RegisterEffect(e1)
	end
end
--Effect 2
function cm.valcheck(e,c)
	local g=e:GetHandler():GetMaterial()
	if #g>=5 then
		e:GetLabelObject():SetLabel(#g)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.uthcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>=5
end
function cm.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsCanBeFusionMaterial()
end
function cm.filter2(c,e,tp,m,chkf)
	if not c:IsType(TYPE_FUSION) then return false end
	local min,max=aux.GetMaterialListCount(c)
	return min==2 and max==2 and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.uthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
		return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function cm.uthop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
		if #mat==0 then return false end
		Duel.SendtoHand(mat,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mat)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--Effect 3 
function cm.cfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.tf(c)
	return c:IsFaceupEx() and c:IsAbleToHand() and c:IsCode(m+1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
	local c=e:GetHandler()
	local b1=c:IsAbleToExtra()
	local b2=Duel.IsExistingMatchingCard(cm.tf,tp,loc,0,1,nil)
	if chk==0 then return b1 and b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED 
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_EXTRA) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tf),tp,loc,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
