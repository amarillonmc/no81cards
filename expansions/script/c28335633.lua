--放课后冰雪女孩！
function c28335633.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCost(c28335633.cost)
	e1:SetTarget(c28335633.target)
	e1:SetOperation(c28335633.activate)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28335633,1))
	--e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)--EFFECT_FLAG_CARD_TARGET
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28335633.cpcon)
	e2:SetCost(c28335633.cpcost)
	e2:SetTarget(c28335633.cptg)
	e2:SetOperation(c28335633.cpop)
	c:RegisterEffect(e2)
	if not c28335633.global_check then
		c28335633.global_check=true
		c28335633.effect_list={}
	end
end
function c28335633.chkfilter(c,tp)
	return c:IsSetCard(0x286) and c:IsLevel(4) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x286,TYPES_TOKEN_MONSTER+TYPE_TUNER,2000,2000,4,RACE_AQUA,c:GetAttribute())
end
function c28335633.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28335633.chkfilter,tp,LOCATION_HAND+0x10,0,1,nil,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c28335633.indexfilter(c,ct)
	return c:GetFlagEffectLabel(28335633)==ct
end
function c28335633.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c28335633.chkfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	if Duel.GetMZoneCount(tp)<=0 or #g==0 then return end
	local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg=g:SelectSubGroup(tp,aux.dabcheck,false,1,ft)
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleHand(tp)
	local fid=e:GetHandler():GetFieldID()
	local sg=Group.CreateGroup()
	for tc in aux.Next(tg) do
		local code=tc:GetCode()
		local attr=tc:GetAttribute()
		local token=Duel.CreateToken(tp,28335634)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(attr)
		token:RegisterEffect(e2)
		local des=aux.Stringid(28335633,2)
		for i,v in pairs({ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_WIND }) do
			if attr==v then des=aux.Stringid(28335633,i+1) break end
		end
		Duel.AdjustAll()
		Duel.Hint(HINT_OPSELECTED,tp,des)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		sg:AddCard(token)
		token:RegisterFlagEffect(28335633,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	Duel.SpecialSummonComplete()
	sg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg)
	e1:SetCondition(c28335633.descon)
	e1:SetOperation(c28335633.desop)
	Duel.RegisterEffect(e1,tp)
end
function c28335633.desfilter(c,fid)
	return c:GetFlagEffectLabel(28335633)==fid
end
function c28335633.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not (g and g:IsExists(c28335633.desfilter,1,nil,e:GetLabel())) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c28335633.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c28335633.desfilter,nil,e:GetLabel())
	--g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function c28335633.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c28335633.efilter(e)
	local ct=#c28335633.effect_list
	if e:IsHasRange(LOCATION_ONFIELD) and e:IsActivated() then c28335633.effect_list[ct+1]=e end
	return false--e:IsHasRange(LOCATION_ONFIELD) and e:IsActivated()
end
function c28335633.cpfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x286) and c:IsSummonableCard() and c:IsAbleToDeckAsCost()) then return false end--and c:IsFaceupEx()
	c28335633.effect_list={}
	c:IsOriginalEffectProperty(c28335633.efilter)
	for _,te in ipairs(c28335633.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,nil,Group.FromCards(c,e:GetHandler())) then return true end
	end
	return false
end
function c28335633.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28335633.cpfilter,tp,LOCATION_HAND,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsAbleToDeckAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c28335633.cpfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.SetTargetCard(g)
	if g:IsExists(Card.IsOnField,1,nil) then
		g:AddCard(e:GetHandler())
		Duel.HintSelection(g)
	else
		Duel.ConfirmCards(1-tp,g)
		Duel.HintSelection(Group.FromCards(e:GetHandler()))
		g:AddCard(e:GetHandler())
	end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c28335633.tdfilter(c)
	return c:IsSetCard(0x286) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function c28335633.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=aux.GetAttributeCount(g)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(0x30) and c28335633.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c28335633.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c) and Duel.IsPlayerCanDraw(tp,1) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectTarget(tp,c28335633.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	local num=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and 1 or 0
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,tg:GetCount()+num,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c28335633.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
end
function c28335633.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	c28335633.effect_list={}
	tc:IsOriginalEffectProperty(c28335633.efilter)
	local e_list={}
	for _,te in ipairs(c28335633.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c28335633.effect_list,i) end
	end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c28335633.effect_list={}
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
end
function c28335633.tdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	local g=Duel.GetTargetsRelateToChain()
	if #tg>0 then g:Merge(tg) end
	if #g==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
