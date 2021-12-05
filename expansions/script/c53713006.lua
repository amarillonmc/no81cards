local m=53713006
local cm=_G["c"..m]
cm.name="ALC之灾 HNS"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.spcost)
	e0:SetOperation(cm.spcop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.fscon)
	e1:SetOperation(cm.fsop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(2,m)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdcon)
	e3:SetTarget(cm.damtg)
	e3:SetOperation(cm.damop)
	c:RegisterEffect(e3)
end
function cm.tffilter(c)
	return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.tffilter2(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost()
end
function cm.fselect(g,e,tp)
	return g:FilterCount(cm.tffilter,nil)==2 and g:FilterCount(cm.tffilter2,nil)==1 and Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())
end
function cm.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
		e:SetLabel(1)
		local g=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(cm.tffilter2,tp,LOCATION_MZONE,0,nil)
		g:Merge(g2)
		return g:CheckSubGroup(cm.fselect,3,3,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1
	else
		e:SetLabel(0)
		return true
	end
end
function cm.spcop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
	local g=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.tffilter2,tp,LOCATION_MZONE,0,nil)
	g:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local sg=g:SelectSubGroup(tp,cm.fselect,false,3,3,e,tp)
	Duel.HintSelection(sg)
	local fg=sg:Filter(cm.tffilter,nil)
	for tc in aux.Next(fg) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	sg:Sub(fg)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
function cm.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	if gc then return false end
	local c=e:GetHandler()
	local tp=c:GetControler()
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,Group.CreateGroup(),c) then return false end
	local chkf=(chkfnf & 0xff)
	return chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf)>-1
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	Duel.SetFusionMaterial(Group.CreateGroup())
end
function cm.setfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and (c:IsSSetable(true) or c:IsCanTurnSet())
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function cm.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x535) and c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) then
		if lc:IsFacedown() then Duel.ConfirmCards(tp,lc) end
		if tc:GetCode()==lc:GetCode() and (tc:IsSSetable(true) or tc:IsCanTurnSet()) and lc:IsAbleToRemove() then
			local rg=Group.CreateGroup()
			rg:AddCard(lc)
			local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
			if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				local sg=g:RandomSelect(tp,1)
				rg:Merge(sg)
			end
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			tc:CancelToGrave()
			Duel.ChangePosition(tc,POS_FACEDOWN)
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
		else
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(lc:GetCode())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)
			tc:RegisterEffect(e1)
		end
		local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,c)
		if c:IsAbleToExtra() and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=sg:Select(tp,1,1,nil,e,tp,nil)
			Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetBattleTarget():GetBaseAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
