--剧场读书
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(71400057,0))
	e1:SetCondition(yume.YumeCon)
	e1:SetOperation(c71400057.op1)
	e1:SetTarget(c71400057.tg1)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400057,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(yume.YumeCon)
	e2:SetTarget(c71400057.tg2)
	e2:SetOperation(c71400057.op2)
	c:RegisterEffect(e2)
end
function c71400057.filter1a(c)
	return c:IsFaceup() and c:IsSetCard(0x714) and c:IsType(TYPE_XYZ)
end
function c71400057.filter1b(c)
	return c:IsSetCard(0x714) and c:IsCanOverlay()
end
function c71400057.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c71400057.filter1a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400057.filter1a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71400057.filter1b,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71400057.filter1a,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71400057.filter1c(c,e,tp,mc)
	return c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) and not c:IsCode(mc:GetCode()) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c71400057.filter1d(c)
	if c:IsType(TYPE_LINK) then return false end
	local num=0
	local xyz=false
	if c:IsType(TYPE_XYZ) then
		xyz=true
		num=c:GetRank()
	else
		num=c:GetLevel()
	end
	return c:IsFaceup() and c:IsSetCard(0x714) and Duel.IsExistingMatchingCard(c71400057.filter1e,0,LOCATION_MZONE,LOCATION_MZONE,1,c,num,xyz)
end
function c71400057.filter1e(c,num,xyz)
	if c:IsType(TYPE_LINK) or not (c:IsFaceup() and c:IsSetCard(0x714)) then return false end
	local num2=0
	local xyz2=false
	if c:IsType(TYPE_XYZ) then
		xyz2=true
		num2=c:GetRank()
	else
		num2=c:GetLevel()
	end
	return xyz2==xyz and num2==num
end
function c71400057.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c71400057.filter1b,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<1 then return end
	Duel.Overlay(tc,g)
	if not (tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToEffect(e)
		and aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c71400057.filter1d,0,LOCATION_MZONE,LOCATION_MZONE,1,nil))
		or tc:IsImmuneToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyzg=Duel.SelectMatchingCard(tp,c71400057.filter1c,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	if xyzg:GetCount()>0 then
		local sc=xyzg:GetFirst()
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		local tg=Group.FromCards(tc)
		sc:SetMaterial(tg)
		Duel.Overlay(sc,tg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if sg:GetCount()>0 then
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c71400057.filter2a(c)
	local g=Duel.GetMatchingGroup(c71400057.filter2b,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_XYZ) and c:IsFaceup() and g:GetCount()>=2 and g:IsExists(c71400057.filter2c,1,nil)
end
function c71400057.filter2b(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsCanOverlay()
end
function c71400057.filter2c(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_XYZ)
end
function c71400057.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c71400057.filter2a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400057.filter2a,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71400057.filter2a,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71400057.filter2d(c,f)
	return math.max(f(c),0)
end
function c71400057.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c71400057.filter2b,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	if g:GetCount()<2 or not g:IsExists(c71400057.filter2c,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sc1=g1:GetFirst()
	if c71400057.filter2c(sc1) then
		local g2=g:Select(tp,1,1,sc1)
		g1:Merge(g2)
	else
		local g2=g:FilterSelect(tp,c71400057.filter2c,1,1,sc1)
		g1:Merge(g2)
	end
	local og=g1:Filter(Card.IsImmuneToEffect,nil,e)
	Duel.Overlay(tc,g1)
	if og:GetCount()<2 then return end
	local atk=og:GetSum(c71400057.filter2d,Card.GetAttack)
	local def=og:GetSum(c71400057.filter2d,Card.GetDefense)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(atk)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(def)
	tc:RegisterEffect(e2)
end