--勇劫兽王 虚空路加斯
local s,id=GetID()
s.named_with_Soldier=1

function s.Soldier(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Soldier
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020965)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,3,s.ovfilter,aux.Stringid(id,0),1,s.xyzop)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_HANDES_SELF)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.discon)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end
function s.ovfilter(c)
	return c:IsFaceup() and s.Soldier(c) and c:IsType(TYPE_XYZ)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:GetLevel()>0 or c:GetRank()>0)
end

function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local val=tc:GetLevel()
	if val==0 then val=tc:GetRank() end
	e:SetLabel(val) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>val then ct=val end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,1-tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES_SELF,nil,0,tp,1)
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local val=e:GetLabel()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>0 then
		if ct>val then ct=val end
		local g=Duel.GetDecktopGroup(1-tp,ct)
		Duel.DisableShuffleCheck()
		if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)>0 then
			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD,nil)
			end
		end
	end
end
function s.pzfilter(c)
	return c:IsCode(40020965) and c:IsFaceup()
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_FZONE) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_PZONE,0,1,nil)) then return false end
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
		and Duel.IsChainDisablable(ev)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
			if rc and rc:IsRelateToEffect(re) and rc:IsLocation(LOCATION_MZONE) and not rc:IsImmuneToEffect(e) then
				local og=rc:GetOverlayGroup()
				if #og>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				c:SetMaterial(Group.FromCards(rc))
				Duel.Overlay(c,Group.FromCards(rc))
			end
		end
	end
end