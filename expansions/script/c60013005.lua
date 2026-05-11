-- 极光剑
Duel.LoadScript("c60013002.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60013001)
	--安息
	Heidemarie.AnXi(c)
	--连结
	Heidemarie.LianJie(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=Duel.GetFlagEffect(tp,m)*100+200
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then Duel.Damage(1-tp,num,REASON_EFFECT) end

	local rg=Duel.GetDecktopGroup(1-tp,1)
	if #rg~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end

	if Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end

end
function cm.fil(c)
	return c:IsCode(60013001) and c:IsFaceup()
end