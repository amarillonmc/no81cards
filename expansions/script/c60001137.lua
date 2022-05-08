--奥法之黄
local m=60001137
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60001129") end) then require("script/c60001129") end
cm.isColorSong=true  --乱色狂歌
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local record=Color_Song.MonsterRecord(c)
	Color_Song.AddCount(c)
end
--e1
function cm.tgf1(c,e,tp)
	return c.isColorSong and c:IsFaceup()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):FilterCount(cm.tgf1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,x,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,x,1-tp,LOCATION_MZONE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):FilterCount(cm.tgf1,nil)
	if not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,x,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,x,x,nil)
	if g:GetCount()==x then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	Color_Song.Zombie_Limit(e,tp)
	Color_Song.UseEffect(e,tp)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):FilterCount(cm.tgf1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,x,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,x,1-tp,LOCATION_MZONE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):FilterCount(cm.tgf1,nil)
	if not Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,x,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,x,x,nil)
	if g:GetCount()==x then
		Duel.Destroy(g,REASON_EFFECT)
	end
	Color_Song.UseEffect(e,tp)
end