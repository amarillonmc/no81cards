--链环傀儡 锆素兵
local m=40010162
local cm=_G["c"..m]
cm.named_with_linkjoker=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_linkjoker
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,2,2)	  
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
  
end
function cm.matfilter(c)
	return cm.linkjoker(c)
end
function cm.thfilter(c)
	return cm.linkjoker(c) and c:IsType(TYPE_LINK) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.DisableShuffleCheck()
	--Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:GetType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,1-tp,1-tp,true,false,POS_FACEDOWN_ATTACK)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_PHASE+PHASE_END)
			e6:SetCountLimit(1)
			e6:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
			e6:SetCondition(cm.flipcon)
			e6:SetOperation(cm.flipop)
			e6:SetLabelObject(tc)
			Duel.RegisterEffect(e6,tp)
			local e7=Effect.CreateEffect(e:GetHandler())
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
			--e7:SetCondition(cm.rcon)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e7,tp)
			local e8=Effect.CreateEffect(e:GetHandler())
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e8,tp)
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_SINGLE)
	de:SetCode(EVENT_CHANGE_POS)
	de:SetReset(RESET_EVENT+RESETS_REDIRECT)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		de:SetCountLimit(1)
	--de:SetLabel(fid2)
	de:SetLabelObject(tc)
		--de:SetCondition(cm.descon)
		de:SetOperation(cm.desop)
	g:GetFirst():RegisterEffect(de,tp)
		end
		local fid2=e:GetHandler():GetFieldID()
		if not tc:GetType(TYPE_MONSTER) then
			while tc do
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
				e1:SetReset(RESET_EVENT+0x47c0000)
				tc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_RACE)
				e2:SetValue(RACE_ALL)
				tc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
				e3:SetValue(0xff)
				tc:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(0)
				tc:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(0)
				tc:RegisterEffect(e5,true)
				tc:RegisterFlagEffect(m+1,RESET_EVENT+0x47c0000+RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET,0,1,fid2)
				tc:SetStatus(STATUS_NO_LEVEL,true)
				tc=g:GetNext()
			end
			Duel.SpecialSummon(g,0,1-tp,1-tp,true,false,POS_FACEDOWN_ATTACK)
			g:KeepAlive()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_PHASE+PHASE_END)
			e6:SetCountLimit(1)
			e6:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
			e6:SetCondition(cm.flipcon)
			e6:SetOperation(cm.flipop)
			e6:SetLabelObject(tc)
			Duel.RegisterEffect(e6,tp)
			local e7=Effect.CreateEffect(e:GetHandler())
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
			--e7:SetCondition(cm.rcon)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e7,tp)
			local e8=Effect.CreateEffect(e:GetHandler())
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e8,tp)
	local de=Effect.CreateEffect(e:GetHandler())
	de:SetType(EFFECT_TYPE_SINGLE)
	de:SetCode(EVENT_CHANGE_POS)
	de:SetReset(RESET_EVENT+RESETS_REDIRECT)
	de:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		de:SetCountLimit(1)
	de:SetLabel(fid2)
	de:SetLabelObject(g)
		de:SetCondition(cm.descon)
		de:SetOperation(cm.desop)
	Duel.RegisterEffect(de,tp)
		end
	end
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m+1)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

