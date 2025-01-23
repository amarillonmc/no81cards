--幽玄龙象※兑占盈亏
--21.07.27
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	local e6=e1:Clone()
	e6:SetCode(EVENT_CUSTOM+m+1)
	e6:SetCondition(aux.TRUE)
	c:RegisterEffect(e6)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451416,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.shcon)
	e2:SetTarget(cm.shtg)
	e2:SetOperation(cm.shop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(xc,v,...)
			local t=Auxiliary.GetValueType(v)
			local g=Group.CreateGroup()
			if t=="Card" then g:AddCard(v) else g=v end
			if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
				Duel.RaiseEvent(g:Filter(Card.IsLocation,nil,LOCATION_DECK),EVENT_CUSTOM+m+1,e,0,0,0,0)
			end
			return _Overlay(xc,v,...)
		end
	end
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp and not (c:IsLocation(LOCATION_DECK) and c:IsControler(tp))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c,ec)
	if not c:IsSetCard(0x3978) and c~=ec then return false end
	local e1,e2=Effect.CreateEffect(ec),Effect.CreateEffect(ec)
	local mi,ma=c:GetTributeRequirement()
	--summon
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	if mi>0 then e1:SetValue(SUMMON_TYPE_ADVANCE) end
	c:RegisterEffect(e1,true)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_PROC)
	e2:SetCondition(cm.ttcon)
	c:RegisterEffect(e2,true)
	local res1,res2=c:IsSummonable(true,nil),c:IsMSetable(true,nil)
	e1:Reset()
	e2:Reset()
	return (res1 or res2),res1,res2
end
function cm.fselect(g,tp)
	return g:IsExists(Card.IsFaceup,1,nil) and g:IsExists(Card.IsFacedown,1,nil) and Duel.GetMZoneCount(tp,g)>0
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return ma>0 and g:CheckSubGroup(cm.fselect,2,2,tp)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,2,2,tp)
	Duel.SendtoHand(sg,nil,REASON_COST)
	c:SetMaterial(nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		local _,s1,s2=cm.smfilter(tc,c)
		if tc:IsLocation(LOCATION_HAND) then
			local mi,ma=c:GetTributeRequirement()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,4))
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SUMMON_PROC)
			e1:SetCondition(cm.ttcon)
			e1:SetOperation(cm.ttop)
			if mi>0 then e1:SetValue(SUMMON_TYPE_ADVANCE) end
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_PROC)
			tc:RegisterEffect(e2,true)
		end
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function cm.shcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEDOWN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.filter(c)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet()) and c:GetSequence()<=4 and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local seq=e:GetHandler():GetPreviousSequence()
	if e:GetHandler():GetPreviousControler()==1-tp then seq=4-seq end
	e:SetLabel(seq)
	local fd=1<<seq
	Duel.Hint(HINT_ZONE,tp,fd)
	Duel.Hint(HINT_ZONE,1-tp,fd<<16)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	if Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)==0 then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,sg,1,0,0)
	end
end
function cm.clfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.filter2(c,e)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet()) and c:GetSequence()<=4 and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.ctfilter(c,e)
	return (c:IsPosition(POS_FACEDOWN_DEFENSE) or c:IsCanTurnSet()) and c:IsControlerCanBeChanged() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() and c:IsControler(tp) and c:GetSequence()<=4
end
function cm.shop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=e:GetLabel()
	local b1=Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)>0
	local g=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_MZONE,0,nil,e)
	if #g==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not (c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) then return end
	local dg=g:Filter(Card.IsCanTurnSet,nil)
	if #dg>0 then
		for tc in aux.Next(dg) do
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			--tc:ClearEffectRelation()
		end
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	Duel.ConfirmCards(1-tp,c)
	g:AddCard(c)
	local sg=Duel.GetMatchingGroup(cm.ctfilter,tp,0,LOCATION_MZONE,nil,e)
	if b1 and #sg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local rg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(rg)
		local rc=rg:GetFirst()
		if rc:IsFaceup() then
			Duel.ChangePosition(rc,POS_FACEDOWN_DEFENSE)
			--rc:ClearEffectRelation()
		end
		if Duel.GetControl(rg,tp) then g:AddCard(rc) end
	end
	g=g:Filter(cm.mzfilter,nil,tp)
	Duel.ShuffleSetCard(g)
	if #g==2 and Duel.SelectYesNo(tp,aux.Stringid(11451619,0)) then
		Duel.SwapSequence(g:GetFirst(),g:GetNext())
	end
	if #g<=2 then return end
	for i=1,10 do
		if not Duel.SelectYesNo(tp,aux.Stringid(11451619,1)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451619,2))
		local wg=g:Select(tp,2,2,nil)
		Duel.SwapSequence(wg:GetFirst(),wg:GetNext())
	end
end