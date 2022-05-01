local m=53729031
local cm=_G["c"..m]
cm.name="心化寂魔 翁席恩"
cm.upside_code=m-25
cm.downside_code=m
cm.HartrazDownside=true
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(cm.rtg)
	e2:SetValue(function(e,c)return true end)
	c:RegisterEffect(e2)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_ADJUST)
	ex:SetRange(0xff)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	ex:SetOperation(cm.backop)
	c:RegisterEffect(ex)
	if not cm.Hartrazcheck then
		cm.Hartrazcheck=true
		cm[5]=Duel.ChangePosition
		Duel.ChangePosition=function(targets,au,ad,du,dd,...)
			local tg=Group.__add(targets,targets)
			local g=tg:Filter(function(c)return _G["c"..c:GetOriginalCode()].HartrazDownside end,nil)
			if (not ad and au==POS_FACEDOWN_DEFENSE) or (ad and ((au and au==POS_FACEDOWN_DEFENSE) or (ad and ad==POS_FACEDOWN_DEFENSE) or (du and du==POS_FACEDOWN_DEFENSE) or (dd and dd==POS_FACEDOWN_DEFENSE))) then
				Duel.SendtoGrave(g,REASON_RULE)
				tg:Sub(g)
			end
			cm[5](tg,au,ad,du,dd,...)
		end
		cm[6]=Duel.SendtoGrave
		Duel.SendtoGrave=function(targets,reason)
			cm.ForcetoUpside(targets,reason)
			cm[6](targets,reason)
		end
		cm[7]=Duel.Destroy
		Duel.Destroy=function(targets,reason,...)
			cm.ForcetoUpside(targets,reason)
			cm[7](targets,reason,...)
		end
		cm[8]=Duel.Release
		Duel.Release=function(targets,reason)
			cm.ForcetoUpside(targets,reason)
			cm[8](targets,reason)
		end
		cm[9]=Duel.Remove
		Duel.Remove=function(targets,pos,reason)
			cm.ForcetoUpside(targets,reason)
			cm[9](targets,pos,reason)
		end
		cm[10]=Duel.SendtoDeck
		Duel.SendtoDeck=function(targets,p,seq,reason)
			cm.ForcetoUpside(targets,reason)
			cm[10](targets,p,seq,reason)
		end
		cm[11]=Duel.SendtoHand
		Duel.SendtoHand=function(targets,p,reason)
			cm.ForcetoUpside(targets,reason)
			cm[11](targets,p,reason)
		end
	end
end
function cm.ForcetoUpside(targets,reason)
	local tg=Group.__add(targets,targets)
	local g=tg:Filter(function(c)return _G["c"..c:GetOriginalCode()].HartrazDownside end,nil)
	if #g>0 and reason&REASON_RULE==REASON_RULE then
		for c in aux.Next(g) do
			local tcode=c.upside_code
			c:SetEntityCode(tcode)
			if c:IsFacedown() then
				Duel.ConfirmCards(0,Group.FromCards(c))
				Duel.ConfirmCards(1,Group.FromCards(c))
			end
			c:ReplaceEffect(tcode,0,0)
			Duel.Hint(HINT_CARD,0,tcode)
			if c:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(c:GetControler()) end
			Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
		end
	end
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c.upside_code or c:GetOriginalCode()~=c.downside_code then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then return end
	local tcode=c.upside_code
	c:SetEntityCode(tcode)
	if c:IsFacedown() then
		Duel.ConfirmCards(tp,Group.FromCards(c))
		Duel.ConfirmCards(1-tp,Group.FromCards(c))
	end
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_CARD,0,tcode)
	if c:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(c:GetControler()) end
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_ONFIELD) and c:GetOriginalCode()==m end
	if c:IsFacedown() then Duel.ConfirmCards(1-tp,c) end
	local tcode=c.upside_code
	Duel.Hint(HINT_CARD,0,m)	
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.Hint(HINT_CARD,0,tcode)
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsAbleToHand,1,nil)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsAbleToHand,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) end
end
