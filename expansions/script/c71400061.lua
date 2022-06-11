--蚀异梦像-植物
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400061.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c71400061.con1)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400061,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c71400061.tg2)
	e2:SetOperation(c71400061.op2)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(93507434,1))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c71400061.con3)
	e3:SetTarget(c71400061.tg3)
	e3:SetOperation(c71400061.op3)
	c:RegisterEffect(e3)
end
function c71400061.filter1(c)
	return c:IsSetCard(0x714) and c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c71400061.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingMatchingCard(c71400061.filter1,tp,LOCATION_MZONE,0,1,nil) and yume.YumeCheck(c)
end
function c71400061.filter2(c)
	return c:IsFaceup() and not c:IsRace(RACE_PLANT)
end
function c71400061.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71400061.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400061.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71400061.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c71400061.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_PLANT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c71400061.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x714)
end
function c71400061.filter3a(c,ft)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsAbleToGrave() and (ft>0 or c:GetSequence()<5)
end
function c71400061.filter3b(c,e,tp,lnk)
	return c:IsSetCard(0x714) and c:IsType(TYPE_LINK) and c:IsLink(lnk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71400061.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local lnk=c:GetReasonCard():GetLink()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71400061.filter3a(chkc,ft) end
	if chk==0 then return Duel.IsExistingTarget(c71400061.filter3a,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft) and Duel.IsExistingMatchingCard(c71400061.filter3b,tp,LOCATION_GRAVE,0,1,nil,e,tp,lnk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c71400061.filter3a,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c71400061.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lnk=c:GetReasonCard():GetLink()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c71400061.filter3b,tp,LOCATION_GRAVE,0,1,nil,e,tp,lnk) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c71400061.filter3b,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lnk)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end