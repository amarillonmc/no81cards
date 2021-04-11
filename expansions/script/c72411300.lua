--观星望远镜
function c72411300.initial_effect(c)
	aux.AddCodeList(c,72411270)
		--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e0:SetValue(72411270)
	c:RegisterEffect(e0)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,72411300+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c72411300.activate)
	c:RegisterEffect(e1)
end
function c72411300.filter1(c)
	return c:IsCode(72411270) and c:IsFaceup()
end
function c72411300.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c72411300.filter1,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(72411300,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end