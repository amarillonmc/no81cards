--飞球造物·拟态球
local m=13254063
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.activate1)
	c:RegisterEffect(e2)
	
	elements={{"tama_elements",{{TAMA_ELEMENT_WATER,1},{TAMA_ELEMENT_LIFE,1}}}}
	cm[c]=elements
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_ORDER,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	local sg=Group.CreateGroup()
	if chk==0 then 
		return mg:GetCount()>0 and mg:IsExists(tama.tamas_selectElementsForAbove,1,nil,mg,sg,el)
	end
	local sg=tama.tamas_selectAllSelectForAbove(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToGrave,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5):Filter(cm.tgfilter,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local tc=g:Select(p,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)~=0 and tc:IsLocation(LOCATION_GRAVE)
			and c:IsRelateToEffect(e) then
			c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,2,0,66)
			local code=tc:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2)
		end
	end
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local c=e:GetHandler()
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5):Filter(cm.tgfilter,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
		local tc=g:Select(p,1,1,nil):GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_REVEAL)~=0 and tc:IsLocation(LOCATION_GRAVE)
			and c:IsRelateToEffect(e) and c:IsFaceup() then
			local code=tc:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_PUBLIC)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2)
		end
	end
end
