--远古造物 阿瓦隆分形虫
dofile("expansions/script/c9910700.lua")
function c9910749.initial_effect(c)
	--flag
	QutryYgzw.AddTgFlag(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,9910749)
	e1:SetTarget(c9910749.drtg)
	e1:SetOperation(c9910749.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9910749.drcon)
	c:RegisterEffect(e2)
end
function c9910749.drfilter(c)
	return c:IsFaceup() and c:IsLevel(1)
end
function c9910749.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c9910749.drfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c9910749.tgfilter(c)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER)
end
function c9910749.setfilter(c,e,tp)
	if not c:IsType(TYPE_MONSTER) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function c9910749.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c9910749.drfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(p,c9910749.tgfilter,p,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-p,tc)
		if tc:IsAbleToGrave() and (not c9910749.setfilter(tc,e,p) or Duel.SelectOption(p,1191,aux.Stringid(9910749,0))==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		elseif c9910749.setfilter(tc,e,p) and Duel.MoveToField(tc,p,p,LOCATION_SZONE,POS_FACEDOWN,true) then
			Duel.ConfirmCards(1-p,tc)
			Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,p,p,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		Duel.ShuffleHand(p)
	else
		local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
		Duel.ConfirmCards(1-p,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function c9910749.cfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER)
end
function c9910749.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910749.cfilter,1,nil)
end
