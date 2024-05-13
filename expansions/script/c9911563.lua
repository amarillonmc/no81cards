--缭绕紫炎蔷薇的低语
dofile("expansions/script/c9911550.lua")
function c9911563.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--scale
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(c9911563.scval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,9911563)
	e3:SetCondition(c9911563.spcon)
	e3:SetTarget(c9911563.sptg)
	e3:SetOperation(c9911563.spop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911563,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CUSTOM+9911563)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e4:SetCountLimit(1,9911564)
	e4:SetTarget(c9911563.thtg)
	e4:SetOperation(c9911563.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(9911563,1))
	e5:SetCode(EVENT_CUSTOM+9911564)
	e5:SetTarget(c9911563.thtg2)
	c:RegisterEffect(e5)
	QutryZyqw.RegisterMergedDelayedEvent(c,9911563,EVENT_SPSUMMON_SUCCESS)
end
function c9911563.scval(e,c)
	local val=0
	if e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,0) then val=5 end
	if e:GetHandler()==Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_PZONE,1) then val=-5 end
	return val
end
function c9911563.mzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c9911563.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9911563.mzfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9911563.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(Card.IsCanBeSpecialSummoned,tp,LOCATION_PZONE,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c9911563.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_PZONE,0,nil,e,0,tp,false,false)
	if ft<1 or #tg<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c9911563.cfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c9911563.fselect(g)
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	return num>0
end
function c9911563.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function c9911563.tffilter(c,e,tp)
	if not (c:IsSetCard(0x6952) and c:IsType(TYPE_PENDULUM)) then return false end
	local b1=(Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not c:IsForbidden()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	return b1 or b2
end
function c9911563.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Clone()
	if chk==0 then
		if #g==0 then return false end
		g=g:Filter(c9911563.cfilter,nil,e)
		return g:CheckSubGroup(c9911563.fselect,2,2)
			and Duel.IsExistingMatchingCard(c9911563.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c9911563.tffilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	g=g:Filter(c9911563.cfilter,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911563.fselect,false,2,2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9911563.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(function(c) return c:GetFlagEffect(9911551)==0 end,nil)
	if chk==0 then
		if #g==0 or not g:IsExists(function(c) return c:GetFlagEffect(9911550)>0 end,1,nil) then return false end
		g=g:Filter(c9911563.cfilter,nil,e)
		return g:CheckSubGroup(c9911563.fselect,2,2)
			and Duel.IsExistingMatchingCard(c9911563.thfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(c9911563.tffilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	g=g:Filter(c9911563.cfilter,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911563.fselect,false,2,2)
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c9911563.cfilter2(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9911563.gselect(g,e,tp,pt,ft)
	local b1=not g:IsExists(Card.IsForbidden,1,nil) and #g<=pt
	local b2=g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)==#g and #g<=ft
	return b1 or b2
end
function c9911563.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9911563.cfilter2,nil,e)
	if #g~=2 then return end
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	if num<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911563.thfilter),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,num,nil)
	if #sg1==0 or Duel.SendtoHand(sg1,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleHand(tp)
	local pt=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pt=pt+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pt=pt+1 end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=Duel.GetMatchingGroup(c9911563.tffilter,tp,LOCATION_HAND,0,nil,e,tp)
	if pt+ft<1 or #tg<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg2=tg:SelectSubGroup(tp,c9911563.gselect,false,1,2,e,tp,pt,ft)
	if #sg2>0 then
		local b1=not sg2:IsExists(Card.IsForbidden,1,nil) and #sg2<=pt
		local b2=sg2:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)==#sg2 and #sg2<=ft
		local opt=-1
		if b1 and not b2 then
			opt=Duel.SelectOption(tp,1160)
		elseif not b1 and b2 then
			opt=Duel.SelectOption(tp,1152)+1
		elseif b1 and b2 then
			opt=Duel.SelectOption(tp,1160,1152)
		end
		if opt==0 then
			for tc in aux.Next(sg2) do
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		elseif opt==1 then
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
