--幻叙之终末 天启骑士
--Talespace Apocalypse Knight
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Pendulum Attribute
	aux.EnablePendulumAttribute(c)
	--Fusion Material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),s.matfilter,2,true)
	--Deck Fusion
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.fuscon)
	e2:SetTarget(s.fustg)
	e2:SetOperation(s.fusop)
	c:RegisterEffect(e2)
	--Multi Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.effcon)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end
function s.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x838) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function s.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function s.filter0(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function s.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.fusfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x838) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionCode,1,nil,65133132)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp,LOCATION_MZONE+LOCATION_GRAVE)
		aux.FCheckAdditional=s.fcheck
		local res=Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.fusfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		Debug.Message(res)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp,LOCATION_MZONE+LOCATION_GRAVE):Filter(s.filter1,nil,e)
	aux.FCheckAdditional=s.fcheck
	local sg1=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.fusfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			aux.FCheckAdditional=s.fcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoDeck(mat1,nil,SEQ_DECKBOTTOM,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	local ct=0
	if mat:IsExists(Card.IsType,1,nil,TYPE_FUSION) then ct=ct+1 end
	if mat:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then ct=ct+1 end
	if mat:IsExists(Card.IsType,1,nil,TYPE_XYZ) then ct=ct+1 end
	if mat:IsExists(Card.IsType,1,nil,TYPE_LINK) then ct=ct+1 end
	if ct>4 then ct=4 end
	if chk==0 then return ct>0 end
	e:SetLabel(ct)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	for i=1,ct do
		--Select effect
		local op=Duel.SelectOption(tp,aux.Stringid(65133132,1),aux.Stringid(65133132,2),aux.Stringid(65133132,3),aux.Stringid(65133132,4))
		if op==0 then
			--Negate monster
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local g=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
			if #g>0 then
				local tc=g:GetFirst()
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e2)
			end
		elseif op==1 then
			--ATK up
			if c:IsRelateToEffect(e) and c:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(1000)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				c:RegisterEffect(e1)
				--Direct attack
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DIRECT_ATTACK)
				e2:SetCondition(s.dircon)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
				c:RegisterEffect(e2)
				c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
			end
		elseif op==2 then
			--Send to GY
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
				local sg=g:Select(1-tp,1,1,nil)
				Duel.SendtoGrave(sg,REASON_RULE)
			end
		elseif op==3 then
			--Banish face-down
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=g:Select(tp,1,1,nil)
				Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end
function s.dircon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and e:GetHandler():GetFlagEffect(id+1)~=0
end