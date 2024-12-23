--双魂重合
function c22348445.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22348445+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22348445.target)
	e1:SetOperation(c22348445.activate)
	c:RegisterEffect(e1)
c22348445.fusion_effect=true
end
function c22348445.mfilter(c,e)
	return not c:IsImmuneToEffect(e) and c:IsOnField() and c:IsAbleToDeck()
end
function c22348445.ffilter1(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
		and Duel.IsExistingMatchingCard(c22348445.ffilter2,tp,LOCATION_EXTRA,0,1,c,e,tp,sg,chkf,c:GetAttribute())
end
function c22348445.ffilter2(c,e,tp,m,chkf,attr)
	return c:IsType(TYPE_FUSION) and not c:IsAttribute(attr) and c:CheckFusionMaterial(m,nil,chkf)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c22348445.mgcheck(sg,e,tp,chkf)
	return Duel.IsExistingMatchingCard(c22348445.ffilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg,chkf)
end
function c22348445.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c22348445.mfilter,nil,e)
	if chk==0 then return mg1:CheckSubGroup(c22348445.mgcheck,2,2,e,tp,chkf) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c22348445.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp):Filter(c22348445.mfilter,nil,e)
	local fg=Duel.GetMatchingGroup(c22348445.ffilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if #fg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mat=mg:SelectSubGroup(tp,c22348445.mgcheck,false,2,2,e,tp,chkf)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc1=Duel.SelectMatchingCard(tp,c22348445.ffilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mat,chkf):GetFirst()
	local sc2=Duel.SelectMatchingCard(tp,c22348445.ffilter2,tp,LOCATION_EXTRA,0,1,1,sc1,e,tp,mat,chkf,sc1:GetAttribute()):GetFirst()
	local sg=Group.FromCards(sc1,sc2)
	sc1:SetMaterial(mat)
	sc2:SetMaterial(mat)
	if mat:IsExists(Card.IsFacedown,1,nil) then
		local cg=mat:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(mat,nil,LOCATION_DECKSHF,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	local ct=Duel.GetTurnPlayer()==1-tp and 2 or 1
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(sg) do
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(22348445,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,ct,fid,aux.Stringid(22348445,0))
	end
	sg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid,Duel.GetTurnCount()+1)
	e1:SetLabelObject(sg)
	e1:SetCondition(c22348445.tdcon)
	e1:SetOperation(c22348445.tdop)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
	Duel.RegisterEffect(e1,tp)
end
function c22348445.tdfilter(c,fid)
	return c:GetFlagEffectLabel(22348445)==fid
end
function c22348445.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	if Duel.GetTurnCount()<ct then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c22348445.tdfilter,1,nil,fid) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c22348445.tdop(e,tp,eg,ep,ev,re,r,rp)
	local fid,ct=e:GetLabel()
	local g=e:GetLabelObject()
	local sg=g:Filter(c22348445.tdfilter,nil,fid)
	g:DeleteGroup()
	Duel.SendtoDeck(sg,nil,LOCATION_DECKTOP,REASON_EFFECT)
end
