--究极混合体
local m=30005503
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddMaterialCodeList(c,30005500,30005501,30005502)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,cm.fus1,cm.fus2,cm.fus3,cm.fus4,cm.fus5)
	--Effect 1
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_SINGLE)
	e02:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e02:SetCondition(cm.subcon)
	c:RegisterEffect(e02)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
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
	e2:SetCountLimit(1,m+m)
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
function cm.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
--Effect 2
function cm.fus7(c)
	return c:IsCode(30005500,30005501,30005502)
end
function cm.valcheck(e,c)
	local g=e:GetHandler():GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_FUSION) 
		and g:IsExists(Card.IsCode,1,nil,30005500)
		and g:IsExists(Card.IsCode,1,nil,30005501)
		and g:IsExists(Card.IsCode,1,nil,30005502) then
		e:GetLabelObject():SetLabel(#g)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==5
end
function cm.filter1(c,e,tp,mg,f,chkf)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
		and mg:IsExists(cm.filter2,1,c,e,tp,c,f,chkf)
end
function cm.filter2(c,e,tp,mc,f,chkf)
	local mg=Group.FromCards(c,mc)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
		and Duel.IsExistingMatchingCard(cm.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,f,chkf)
end
function cm.ffilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
		local res=mg1:IsExists(cm.filter1,1,nil,e,tp,mg1,nil,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
	local g1=mg1:Filter(cm.filter1,nil,e,tp,mg1,nil,chkf)
	if #g1>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg1=mg1:FilterSelect(tp,cm.filter1,1,1,nil,e,tp,mg1,nil,chkf)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg1:FilterSelect(tp,cm.filter2,1,1,nil,e,tp,sg1:GetFirst(),nil,chkf)
		sg1:Merge(sg2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=Duel.SelectMatchingCard(tp,cm.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,sg1,nil,chkf)
		local tc=sg:GetFirst()
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--Effect 3 
function cm.cfilter(c)
	return c:IsType(TYPE_FUSION) and  c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.tf(c)
	return c:IsAbleToHand() and c:IsCode(m+1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsAbleToExtra()
	local b2=Duel.IsExistingMatchingCard(cm.tf,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 and b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tf,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
