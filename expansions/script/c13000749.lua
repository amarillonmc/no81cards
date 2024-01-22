--学舌鹦鹉
local m=13000749
local cm=_G["c"..m]
function c13000749.initial_effect(c)
c:EnableReviveLimit()
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.chkfilter(c,i)
	return c:GetSequence()==i
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local snum=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_RITUAL)
	if snum<=0 then return end
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	if not g2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,snum,nil)
	if not g1 then return end
	snum=g1:GetCount()
	local num=0
	Duel.ConfirmCards(1-tp,g1)
	for i=1,#g2,1 do
		if num==snum then break end
		local tc=Duel.GetMatchingGroup(cm.chkfilter,tp,LOCATION_DECK,0,nil,#g2-i):GetFirst()
		if tc:IsType(TYPE_RITUAL) then
			snum=snum+1
		end
		num=num+1
	end
	if num>=#g2 then
		Duel.ConfirmDecktop(tp,#g2)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
		return
	end
	Duel.ConfirmDecktop(tp,num)
	Duel.ShuffleHand(tp)
	::cancel::
	local g=Duel.GetDecktopGroup(tp,num)
	local mg=Duel.GetRitualMaterial(tp)
	if not mg then mg=Group.CreateGroup() end
	local mg2=g:Filter(cm.filter4,nil)
	if mg2 then mg:Merge(mg2) end
	if mg:GetCount()>0 then
		Duel.BreakEffect()
		local tg=Duel.GetMatchingGroup(cm.filter9,tp,LOCATION_HAND,0,nil,e,tp,mg)
		if not tg then tg=Group.CreateGroup() end
		local tg1=g:Filter(cm.filter9,nil,e,tp,mg)
		if tg1 then tg:Merge(tg1) end
		if tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tg=tg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				if tc.mat_filter then
					mg=mg:Filter(tc.mat_filter,tc,tp)
				else
					mg:RemoveCard(tc)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
				local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
				aux.GCheckAdditional=nil
				if not mat then
					aux.RCheckAdditional=nil
					aux.RGCheckAdditional=nil
					goto cancel
				end
				tc:SetMaterial(mat)
				local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
				if dmat:GetCount()>0 then
					mat:Sub(dmat)
					Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
				end
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
	Duel.ShuffleDeck(tp)
end
function cm.hspgcheck(td,lv)   
	return td:CheckWithSumGreater(Card.GetLevel,lv)
end
function cm.filter9(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil,tp)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
end
function cm.matfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.filter4(c)
	return c:IsType(TYPE_RITUAL) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end


function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_HAND) end
	local c=e:GetHandler()
	local b1=true
	local b2=e:GetHandler():IsPublic() and c:IsAbleToRemove()
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,1)})
	if op==1 then
		Duel.SendtoHand(e:GetHandler(),1-tp,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(66)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
	end
	if op==2 then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetOperation(cm.op3)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.GetMatchingGroupCount(nil,tp,LOCATION_DECK,0,nil)>0
end
end
function cm.filter3(c)
	return not c:IsType(TYPE_RITUAL)
end
function cm.filter2(c)
	return c:IsType(TYPE_RITUAL) and not c:IsPublic()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for tc in aux.Next(eg) do
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e0:SetValue(13000749)
			tc:RegisterEffect(e0)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(1)
			tc:RegisterEffect(e1)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e5)
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e6)
	end
end





