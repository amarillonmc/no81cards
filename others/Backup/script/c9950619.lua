--咕噜灵波（物理）
function c9950619.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,995019+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9950619.target)
	e1:SetOperation(c9950619.activate)
	c:RegisterEffect(e1)
end
function c9950619.gfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9950619.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c9950619.gfilter,tp,LOCATION_MZONE,0,nil)
		local ct=c9950619.count_unique_code(g)
		e:SetLabel(ct)
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c9950619.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c9950619.gfilter,tp,LOCATION_MZONE,0,nil)
	local ct=c9950619.count_unique_code(g)
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c9950619.count_unique_code(g)
	local check={}
	local count=0
	local tc=g:GetFirst()
	while tc do
		for i,code in ipairs({tc:GetCode()}) do
			if not check[code] then
				check[code]=true
				count=count+1
			end
		end
		tc=g:GetNext()
	end
	return count
end

