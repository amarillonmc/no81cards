--烬羽的残迹·珍妮丽丝
local cm,m=GetID()
function cm.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DISCARD)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	--hint
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(cm.chkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
end
local KOISHI_CHECK=false
if Card.SetEntityCode then KOISHI_CHECK=true end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsReason(REASON_DISCARD) then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1f20000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451742,0))
	end
end
function cm.filter(c)
	return c:IsCode(m+4) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 and c:IsRelateToEffect(e) and c:IsAbleToDeck() then
		if KOISHI_CHECK then
			c:SetEntityCode(m+48,true)
			cm.proeffects=cm.proeffects or {}
			local _SetProperty=Effect.SetProperty
			local _Clone=Effect.Clone
			Effect.SetProperty=function(pe,prop1,prop2)
				if not prop2 then prop2=0 end
				if prop1&EFFECT_FLAG_UNCOPYABLE~=0 then
					cm.proeffects[pe]={prop1,prop2}
					prop1=prop1&(~EFFECT_FLAG_UNCOPYABLE)
				else
					cm.proeffects[pe]=nil
				end
				return _SetProperty(pe,prop1,prop2)
			end
			Effect.Clone=function(pe)
				local ce=pe:Clone()
				if cm.proeffects[pe] then
					cm.proeffects[ce]=cm.proeffects[pe]
				end
				return ce
			end
			c:ReplaceEffect(m+48,0)
			Effect.SetProperty=_SetProperty
			Effect.Clone=_Clone
			for ke,vp in pairs(cm.proeffects) do
				local prop1,prop2=table.unpack(vp)
				ke:SetProperty(prop1|EFFECT_FLAG_UNCOPYABLE,prop2)
			end
			--[[c:EnableReviveLimit()
			aux.AddLinkProcedure(c,cm.matfilter,2,2)--]]
			local loc=c:GetLocation()
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
			local g=Duel.GetFieldGroup(tp,loc,0)
			Duel.ConfirmCards(tp,g)
		else
			Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
			local token=Duel.CreateToken(tp,m+48)
			Duel.SendtoDeck(token,nil,2,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,token)
			--change code
			local e3=Effect.CreateEffect(token)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_CODE)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
			e3:SetValue(m+48)
			token:RegisterEffect(e3)
		end
	end
end
function cm.matfilter(c)
	return c:IsLinkRace(RACE_FAIRY)
end