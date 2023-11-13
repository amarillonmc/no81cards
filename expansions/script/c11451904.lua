--迷托邦迹巡 迷绊
local cm,m=GetID()
function cm.initial_effect(c)
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.accon)
	e2:SetOperation(cm.acop)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e6)
end
function cm.filter(c,e,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c:IsAbleToRemove() and c:GetLeaveFieldDest()==0 and not c:IsHasEffect(EFFECT_TO_HAND_REDIRECT) and c:GetDestination()==LOCATION_HAND --and not c:IsType(TYPE_TOKEN)
end
function cm.filter3(c,e,tp,eg)
	return (c:GetOriginalCode()==m or c==e:GetHandler()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and eg:IsExists(cm.filter,1,c,e,tp)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_GRAVE,0,nil,e,tp,eg)
	if chk==0 then
		if #Group.__band(sg,eg)==0 and c~=sg:GetFirst() then return false end
		return sg:IsContains(c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end --and c==sg:GetFirst() end -- and Duel.GetFlagEffect(tp,m)==0 end
	--Duel.HintSelection(Group.FromCards(c))
	local g=eg:Filter(cm.filter,c,e,tp)
	local desc=aux.Stringid(m,0)
	if eg:IsContains(c) then desc=aux.Stringid(m,1) end
	if #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,desc) then
		--Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		if #g>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g=g:Select(tp,1,1,nil)
		end
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_HAND_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		return true
	else return false end
end
function cm.accon(e)
	cm[0]=false
	return true
end
function cm.acfilter(c,tp)
	return c:IsSetCard(0xc976) and c:IsAbleToGraveAsCost() and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,c:GetCode()) --and Duel.GetFlagEffect(tp,m+c:GetCode()+0xffffff)==0
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if cm[0] then return end
	if e:GetHandler():GetFlagEffect(m)>0 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.acfilter,tp,LOCATION_DECK,0,0,1,nil,tp)
	if #g>0 then
		--Duel.RegisterFlagEffect(tp,m+g:GetFirst():GetCode()+0xffffff,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST)
	else
		local cg=Duel.GetMatchingGroup(cm.cfilterx,tp,LOCATION_MZONE,0,nil)
		cg:AddCard(e:GetHandler())
		if #cg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			cg=cg:Select(tp,1,1,nil)
		end
		Duel.HintSelection(cg)
		cg:KeepAlive()
		cg:ForEach(Card.RegisterFlagEffect,m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(cg:GetFirst())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetLabelObject(cg)
		e1:SetOperation(cm.desop)
		e1:SetReset(RESET_CHAIN)
		e1:SetLabel(Duel.GetCurrentChain()+1)
		Duel.RegisterEffect(e1,tp)
	end
	cm[0]=true
end
function cm.cfilterx(c)
	return c:IsHasEffect(m) and c:GetFlagEffect(m+1)==0
end
function cm.cfilter(c)
	return c:IsHasEffect(m) and c:GetFlagEffect(m+1)>0 and c:IsDestructable()
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==ev then
		Duel.Hint(HINT_CARD,0,m)
		local cg=e:GetLabelObject():Filter(cm.cfilter,nil)
		if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then cg:AddCard(re:GetHandler()) end
		if #cg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			cg=cg:Select(tp,1,1,nil)
		end
		if #cg>0 then Duel.Destroy(cg,REASON_EFFECT) end
		e:GetLabelObject():DeleteGroup()
	end
end