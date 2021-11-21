--SCP-173 雕像-最初之作
if not pcall(function() require("expansions/script/c16101100") end) then require("script/c16101100") end
local m,cm=rscf.DefineCard(16102005,"SCP")
function cm.initial_effect(c)
	local e1=rscf.SetSummonCondition(c,false)
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_HAND,cm.sprcon,cm.sprop)
	local e3=rsef.FTO(c,EVENT_CHAIN_SOLVING,{m,0},{1,m},"des","de",LOCATION_MZONE,cm.descon,nil,rsop.target(aux.TRUE,"des",0,LOCATION_ONFIELD),cm.desop)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(cm.atlimit)
	c:RegisterEffect(e4)
	local e5=rsef.SV_REDIRECT(c,"leave",LOCATION_HAND,rscon.excard2(rscf.CheckSetCard,LOCATION_ONFIELD,0,1,nil,"SCP_J"))
end
function cm.spcfilter(c,tp)
	return c:IsReleasable() and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function cm.spzfilter(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.sprcon(e,c,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	return (g1+g2):IsExists(cm.spzfilter,1,nil,tp)
end
function cm.sprop(e,tp)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Card.IsCode,nil,16102002)
	local g2=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil,tp)
	local sg=(g1+g2):SelectSubGroup(tp,cm.spzfilter,false,1,1,tp)
	Duel.Release(sg,REASON_COST)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
function cm.desop(e,tp)
	local ct,og,rc=rsop.SelectDestroy(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil,{})
	if rc and not rc:IsLocation(LOCATION_HAND+LOCATION_DECK)
		and not rc:IsHasEffect(EFFECT_NECRO_VALLEY) then
		if rc:IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and (not rc:IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,nil,rc)>0)
			and rc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,rc)
		elseif (rc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			and rc:IsSSetable() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.SSet(tp,rc)
		end
	end
end
function cm.atlimit(e,c)
	return c~=e:GetHandler()
end