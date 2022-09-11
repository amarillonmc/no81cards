--耀辉机 时绽
local m=30005130
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,5,false)
	--material limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(cm.matlimit)
	c:RegisterEffect(e0)
	local e31=Effect.CreateEffect(c)
	e31:SetType(EFFECT_TYPE_SINGLE)
	e31:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e31:SetCode(EFFECT_SPSUMMON_CONDITION)
	e31:SetValue(aux.fuslimit)
	c:RegisterEffect(e31)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.anctg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--Effect 2
	local e32=Effect.CreateEffect(c)
	e32:SetDescription(aux.Stringid(m,4))
	e32:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e32:SetType(EFFECT_TYPE_IGNITION)
	e32:SetRange(LOCATION_GRAVE)
	e32:SetCountLimit(1)
	e32:SetTarget(cm.rettg)
	e32:SetOperation(cm.retop)
	c:RegisterEffect(e32)  
	--Effect 3 
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,5))
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_GRAVE_ACTION)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetCountLimit(1)
	e12:SetTarget(cm.tetg)
	e12:SetOperation(cm.teop)
	c:RegisterEffect(e12)  
end
function cm.ffilter(c,fc,sub,mg,sg)
	if not sg then return true end
	local chkloc=LOCATION_HAND
	if c:IsOnField() then chkloc=LOCATION_ONFIELD end
	return not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
		and (not c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) or #sg<2 or sg:IsExists(aux.NOT(Card.IsLocation),1,c,chkloc))
end
function cm.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsLocation(LOCATION_HAND) or c:IsControler(fc:GetControler())   and c:IsOnField()
end
--Effect 1
function cm.valcheck(e,c)
	local g=e:GetHandler():GetMaterialCount()
	e:GetLabelObject():SetLabel(g)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and g>4
end
function cm.anctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCard(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac2=Duel.AnnounceCard(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac3=Duel.AnnounceCard(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac4=Duel.AnnounceCard(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac5=Duel.AnnounceCard(tp)
	e:SetOperation(cm.codeop(ac1,ac2,ac3,ac4,ac5))
end
function cm.codeop(ac1,ac2,ac3,ac4,ac5)
	return
		function (e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			local tsp=e:GetHandlerPlayer()
			local e12=Effect.CreateEffect(c)
			e12:SetType(EFFECT_TYPE_FIELD)
			e12:SetRange(LOCATION_MZONE)
			e12:SetCode(EFFECT_CANNOT_ACTIVATE)
			e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e12:SetAbsoluteRange(tsp,0,1)
			e12:SetLabel(ac1,ac2,ac3,ac4,ac5)
			e12:SetValue(cm.aclimit)
			e12:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e12)
		end
end
function cm.aclimit(e,re,tp)
	local ac1,ac2,ac3,ac4,ac5=e:GetLabel()
	local tc=re:GetHandler()
	return tc:IsCode(ac1,ac2,ac3,ac4,ac5)
end
--Effect 2
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e)  then return end
	if  Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_EXTRA) then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) 
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			local tc=c
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
end
function cm.filter1(c,e)
	return  not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c==e:GetHandler() and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
--Effect 3 
function cm.tefilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function cm.tetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.tefilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,c) and c:IsAbleToExtra() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tefilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,5,5,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,6,0,0)
end
function cm.teop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e)  then return end
	if g:GetCount()>0 and c:IsAbleToExtra() then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
 

