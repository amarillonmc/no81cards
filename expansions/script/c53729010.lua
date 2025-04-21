local m=53729010
local cm=_G["c"..m]
cm.name="不遏心化 因弗诺"
cm.upside_code=m
cm.downside_code=m+25
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,function(c)return c:IsLevelBelow(4) and c:IsLinkRace(RACE_PYRO)end,1,1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsHasEffect(EFFECT_LINK_SPELL_KOISHI) and e:GetHandler():GetFlagEffect(m)>0 end)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_LINK) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	SNNM.LinkMonstertoSpell(c,0x100)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
function cm.xylabel(c,tp)
	local x,y=c:GetSequence(),0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then y=0
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		else x,y=-1,-5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then x,y=4-x,4
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		else x,y=5,9 end
	end
	return x,y
end
function cm.gradient(y,x)
	if y>0 and x==0 then return 1000 end
	if y<0 and x==0 then return 1100 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+100 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 100 end
	return 65536
end
function cm.line(tc,c,tp,...)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(tc,tp)
	for _,k in ipairs({...}) do if cm.gradient(y2-y1,x2-x1)==k then return true end end
	return false
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local t1,t2,t3,t4={101,1100,99,100,0,-1,1000,1},{0x001,0x002,0x004,0x008,0x020,0x040,0x080,0x100},{},{}
	local l=c:GetLinkMarker()
	if l==0 then return false end
	for i=1,8 do if l&t2[i]==t2[i] then table.insert(t3,i) end end
	for i=1,#t3 do
		local n=t3[i]
		table.insert(t4,t1[n])
	end
	if chkc then return chkc:IsOnField() and cm.line(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.line,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c,tp,table.unpack(t4)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.line,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,99,nil,c,tp,table.unpack(t4))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then Duel.Destroy(g,REASON_EFFECT) end
end
