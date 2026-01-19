--人理之星 迷之兰丸·X
function c22024970.initial_effect(c)
	aux.AddCodeList(c,22020631)
	--link summon
	aux.AddLinkProcedure(c,c22024970.mfilter,1,1)
	c:EnableReviveLimit()
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024970,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,22024970)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c22024970.sptg1)
	e1:SetOperation(c22024970.spop1)
	c:RegisterEffect(e1)
	--token ere
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22024970,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,22024970)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22024970.erecon)
	e2:SetCost(c22024970.erecost)
	e2:SetTarget(c22024970.sptg)
	e2:SetOperation(c22024970.spop)
	c:RegisterEffect(e2)
	--Xyz
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22024970,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,22024971)
	e3:SetCondition(c22024970.imcon)
	e3:SetTarget(c22024970.sptg)
	e3:SetOperation(c22024970.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c22024970.imcon1)
	c:RegisterEffect(e4)
end
function c22024970.mfilter(c)
	return (c:IsLinkSetCard(0xff1) and c:IsLevelBelow(4)) or c:IsLinkCode(22020631)
end
function c22024970.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22024970.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,22020631,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,22020631)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22024970,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c22024970.erecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22024970.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c22024970.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22024970.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22024970.xfilter1(c)
	return c:GetSequence()==0
end
function c22024970.xfilter2(c)
	return c:GetSequence()==2
end
function c22024970.xfilter3(c)
	return c:GetSequence()==4
end
function c22024970.imcon(e)
	return e:GetHandler():GetSequence()==5 and Duel.IsExistingMatchingCard(c22024970.xfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024970.xfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024970.xfilter3,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c22024970.xfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function c22024970.spfilter(c,e,tp,mc)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_XYZ) and c:IsRankBelow(6) and c:IsRace(RACE_FIEND+RACE_WARRIOR) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c22024970.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c22024970.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22024970.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22024970.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end


function c22024970.imcon1(e)
	return e:GetHandler():GetSequence()==6 and Duel.IsExistingMatchingCard(c22024970.xfilter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024970.xfilter3,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22024970.xfilter1,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c22024970.xfilter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end