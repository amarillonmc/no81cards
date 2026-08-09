local m=31400201
local cm=_G["c"..m]
cm.name="古遗物-流星锤"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(cm.descon)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.sccon)
	e4:SetTarget(cm.sctg)
	e4:SetOperation(cm.scop)
	c:RegisterEffect(e4)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEDOWN) and c:IsPreviousControler(tp) and c:IsReason(REASON_DESTROY) and Duel.GetTurnPlayer()~=tp
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.filter(c)
	return c:IsSetCard(0x97) and c:IsType(TYPE_MONSTER) and c:IsSSetable() and not c:IsCode(31400201)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 or Duel.SSet(tp,g)<=0 then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if #g<=0 or not Duel.SelectYesNo(tp,aux.Stringid(m,3)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg)
	Duel.Destroy(tg,REASON_EFFECT)
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.syncheck(g,tp,syncard)
	return g:IsExists(Card.IsSetCard,1,nil,0x97) and aux.SynMixHandCheck(g,tp,syncard) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1)
end
function cm.synfilter(c,tp,mg)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	aux.GCheckAdditional=aux.SynGroupCheckLevelAddition(c)
	local res=mg:CheckSubGroup(cm.syncheck,2,#mg,tp,c)
	aux.GCheckAdditional=nil
	return res
end
function cm.syntgcheck(tp,chk)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if chk==0 then return #g>0 end
	return g
end
function cm.xyzcheck(g,xyzcard)
	return g:IsExists(Card.IsSetCard,1,nil,0x97) and xyzcard:IsXyzSummonable(g,#g,#g)
end
function cm.xyzfilter(c,mg)
	return c:IsType(TYPE_XYZ) and mg:CheckSubGroup(cm.xyzcheck,1,#mg,c)
end
function cm.xyztgcheck(tp,chk)
	local mg=Duel.GetMatchingGroup(function(c) return c:IsCanOverlay() and c:IsFaceup() end,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return #g>0 end
	return g
end
function cm.linkcheck(g,linkcard)
	return g:IsExists(Card.IsSetCard,1,nil,0x97) and linkcard:IsLinkSummonable(g,nil,#g,#g)
end
function cm.linkfilter(c,tp)
	local mg=aux.GetLinkMaterials(tp,nil,c,nil)
	return c:IsType(TYPE_LINK) and mg:CheckSubGroup(cm.linkcheck,1,#mg,c)
end
function cm.linktgcheck(tp,chk)
	local g=Duel.GetMatchingGroup(cm.linkfilter,tp,LOCATION_EXTRA,0,nil,tp)
	if chk==0 then return #g>0 end
	return g
end
function cm.allcheck(tp,chk)
	local g=Group.CreateGroup()
	g:Merge(cm.syntgcheck(tp))
	g:Merge(cm.xyztgcheck(tp))
	g:Merge(cm.linktgcheck(tp))
	if chk==0 then return #g>0 end
	return g
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummon(tp) and cm.allcheck(tp,chk)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=cm.allcheck(tp)
	if #g<=0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsType(TYPE_SYNCHRO) then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,cm.syncheck,false,2,#mg,tp,tc)
		Duel.SynchroSummon(tp,tc,nil,tg,#tg-1,#tg-1)
	end
	if tc:IsType(TYPE_XYZ) then
		local mg=Duel.GetMatchingGroup(function(c) return c:IsCanOverlay() and c:IsFaceup() end,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg=mg:SelectSubGroup(tp,cm.xyzcheck,false,1,#mg,tc)
		Duel.XyzSummon(tp,tc,tg,#tg,#tg)
	end
	if tc:IsType(TYPE_LINK) then
		local mg=aux.GetLinkMaterials(tp,nil,tc,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local tg=mg:SelectSubGroup(tp,cm.linkcheck,false,1,#mg,tc)
		Duel.LinkSummon(tp,tc,tg,nil,#tg,#tg)
	end
end