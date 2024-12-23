--幽火军团·增援
function c51847025.initial_effect(c)
	--Activate select
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,51847025)
	--e1:SetCost(c51847025.cost)
	e1:SetTarget(c51847025.target)
	--e1:SetOperation(c51847025.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(51847025,ACTIVITY_CHAIN,c51847025.chainfilter)
c51847025.fusion_effect=true
end
function c51847025.chainfilter(re,tp,cid)
	return re:GetHandler():IsOriginalSetCard(0xa67) or not re:IsActiveType(TYPE_MONSTER)
end
function c51847025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(51847025,tp,ACTIVITY_CHAIN)<=1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c51847025.actcon)
	e1:SetValue(c51847025.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51847025.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCustomActivityCount(51847025,tp,ACTIVITY_CHAIN)~=0
end
function c51847025.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0xa67)
end
function c51847025.spxfilter(c,e,tp,tc,num,check)
	return c:IsType(TYPE_XYZ) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0 and tc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
	and ((check==0 and (c:GetRank()-tc:GetRank()==num or tc:GetRank()-c:GetRank()==num))
	or (check==1 and c:IsSetCard(0xa67) and not c:IsOriginalCodeRule(tc:GetOriginalCodeRule())))
end
function c51847025.xyzcheck(g,e,tp,tc,check)
	local lg=g:Filter(Card.IsSetCard,nil,0xa67)
	return (not lg and Duel.IsExistingMatchingCard(c51847025.spxfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc,0)) or (lg and Duel.IsExistingMatchingCard(c51847025.spxfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc,lg:GetSum(Card.GetLevel),check))
end
function c51847025.xyzfilter(c,e,tp,check)
	if not (c:IsSetCard(0xa67) and c:IsType(TYPE_XYZ) and c:IsFaceup()) then return false end
	local g=c:GetOverlayGroup()
	return (g and g:CheckSubGroup(c51847025.xyzcheck,1,#g,e,tp,c,check) and check==0) or (check==1
		and Duel.IsExistingMatchingCard(c51847025.spxfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,0,check))
end
function c51847025.spffilter(c,e,tp,tc,g)
	local xg=g:Clone()
	xg:AddCard(tc)
	local exg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_MZONE,0,tc,0xa67)
	local mg=xg:Clone()
	mg:Merge(exg)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
		and (c:CheckFusionMaterial(xg,tc) or mg:CheckSubGroup(c51847025.fscheck,1,#mg,tc,c))
end
function c51847025.fscheck(g,tc,fc)
	return fc:CheckFusionMaterial(g,tc) and g:FilterCount(Card.IsSetCard,nil,0xa67)==#g and g:FilterCount(Card.IsLocation,tc,LOCATION_HAND+LOCATION_MZONE)==1
end
function c51847025.fsfilter(c,e,tp)
	if not (c:IsSetCard(0xa67) and c:IsType(TYPE_XYZ) and c:IsFaceup()) or c:IsImmuneToEffect(e) then return false end
	local g=c:GetOverlayGroup()
	return Duel.IsExistingMatchingCard(c51847025.spffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,g)
end
function c51847025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	local check=0
	if Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then check=1 end
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c51847025.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,check)
	local b2=Duel.IsExistingMatchingCard(c51847025.fsfilter ,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local code=Duel.AnnounceCard(tp)
	e:SetLabel(code,check)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(51847025,0)},
		{b2,aux.Stringid(51847025,1)})
	if op==1 then
		e:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c51847025.xyzop)
	else
		e:SetCategory(CATEGORY_ANNOUNCE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		e:SetOperation(c51847025.fsop)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c51847025.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local code,chk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,c51847025.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,chk):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	local num=0
	if chk==0 then
		local g=tc:GetOverlayGroup()
		if not g then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local sg=g:SelectSubGroup(tp,c51847025.xyzcheck,false,1,#g,e,tp,tc,chk)
		if not sg then return end
		Duel.SendtoGrave(sg,REASON_EFFECT)
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
		local lg=sg:Filter(Card.IsSetCard,nil,0xa67)
		num=lg:GetSum(Card.GetLevel)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51847025.spxfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,num,chk):GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(51847025,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(code)
		sc:RegisterEffect(e1,true)
	end
end
function c51847025.fcheck(tp,sg,fc)
	if sg:FilterCount(Card.IsSetCard,nil,0xa67)==#sg then
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)<=2
	else
		return sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)<=1
	end
end
function c51847025.gcheck(tp)
	return  function(sg)
				return sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)<=2
			end
end
function c51847025.fsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tc=Duel.SelectMatchingCard(tp,c51847025.fsfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	local g=tc:GetOverlayGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c51847025.spffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,g):GetFirst()
	--material
	local xg=g:Clone()
	xg:AddCard(tc)
	local exg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_MZONE,0,tc,0xa67)
	local mg=xg:Clone()
	mg:Merge(exg)
	aux.FCheckAdditional=c51847025.fcheck
	aux.GCheckAdditional=c51847025.gcheck(tp)
	local mat=Duel.SelectFusionMaterial(tp,sc,mg,tc)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	sc:SetMaterial(mat)
	Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
	local code,check=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(51847025,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(code)
	sc:RegisterEffect(e1,true)
end
