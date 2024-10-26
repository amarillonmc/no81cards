--幽玄龙象※震辟洊雷
--21.09.21
local cm,m=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.ptcon)
	e2:SetTarget(cm.pttg)
	e2:SetOperation(cm.ptop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if not loc then return false end
	if loc==LOCATION_MZONE then if seq==5 then seq=1 elseif seq==6 then seq=3 end end
	return loc&LOCATION_ONFIELD>0 and seq<5 and not Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,re:GetHandler(),p,seq)
end
function cm.actfilter(c,p,seq)
	return aux.GetColumn(c,p)==seq
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c,ec)
	return (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)) and (c:IsSetCard(0x3978) or c==ec)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if tc:IsSummonable(true,nil,1) or tc:IsMSetable(true,nil,1) then
			--tribute
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_MATERIAL_CHECK)
			e2:SetValue(cm.valcheck)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SUMMON_COST)
			e3:SetOperation(cm.facechk)
			e3:SetLabelObject(e2)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_MSET_COST)
			tc:RegisterEffect(e4)
		end
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function cm.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local tc=g:GetFirst()
	if e:GetLabel()==1 then
		e:SetLabel(0)
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	elseif e:GetLabel()==2 then
		e:SetLabel(0)
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
	e:Reset()
end
function cm.facechk(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0 then
		e:GetLabelObject():SetLabel(1)
	--else
		--e:GetLabelObject():SetLabel(2)
	--end
	e:Reset()
end
function cm.ptcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEDOWN) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
local _IsCanChangePosition=Card.IsCanChangePosition
function Card.IsCanChangePosition(c)
	return _IsCanChangePosition(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.pttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #cg>0 end
	local seq=e:GetHandler():GetPreviousSequence()
	if e:GetHandler():GetPreviousControler()==1-tp then seq=4-seq end
	e:SetLabel(seq)
	local fd=1<<seq
	Duel.Hint(HINT_ZONE,tp,fd)
	Duel.Hint(HINT_ZONE,1-tp,fd<<16)
	if Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		e:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function cm.clfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end
function cm.ptop(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,nil)
	local seq=e:GetLabel()
	local ct=Duel.ChangePosition(cg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	if ct>0 and Duel.GetMatchingGroupCount(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,seq)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end