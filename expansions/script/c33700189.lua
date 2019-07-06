--剧透警报！！
local m=33700189
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCountLimit(1)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ac=Duel.AnnounceCard(1-Duel.GetTurnPlayer())
		e:SetLabel(ac)
		e:GetHandler():SetHint(CHINT_CARD,ac)
	end)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e0)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local tcode=e:GetLabelObject():GetLabel()
		for _,code in ipairs(cm.check[Duel.GetTurnPlayer()]) do
			if tcode==code then return true end
		end
		return false
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local p=1-Duel.GetTurnPlayer()
		local op=0
		if Duel.IsPlayerCanDraw(p,1) then
			op=Duel.SelectOption(p,aux.Stringid(m,0),aux.Stringid(m,1))
		else
			op=1
		end
		e:SetLabel(op)
		if op==0 then
			e:SetCategory(CATEGORY_DRAW)
			Duel.SetTargetPlayer(p)
			Duel.SetTargetParam(1)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,1)
		else
			e:SetCategory(CATEGORY_DAMAGE)
			Duel.SetTargetPlayer(1-p)
			Duel.SetTargetParam(1000)
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-p,1000)
		end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if e:GetLabel()==0 then
			Duel.Draw(p,d,REASON_EFFECT)
		else Duel.Damage(p,d,REASON_EFFECT) end
	end)
	c:RegisterEffect(e2)
	if not cm.check then
		cm.check={
			[0]={},
			[1]={},
		}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			for tc in aux.Next(eg) do
				table.insert(cm.check[ep],tc:GetCode())
			end
		end)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			cm.check[0]={}
			cm.check[1]={}
		end)
		Duel.RegisterEffect(ge1,0)		
	end
end
