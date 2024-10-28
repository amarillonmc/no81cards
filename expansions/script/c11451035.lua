--多维镜宙 可测集
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,bool)
			local res=_CRegisterEffect(c,e,bool)
			if res and Duel.GetTurnCount()>0 and e:IsActivated() and c:IsLocation(LOCATION_DECK) and (not PNFL_MIRROR_COPY or PNFL_MIRROR_COPY[c:GetControler()][e]) then
				local te=PNFL_MIRROR_COPY[c:GetControler()][e]
				if (PNFL_MIRROR_COPIED[1-c:GetControler()][te] or (PNFL_MIRROR_MULTI[c:GetOriginalCode()] and PNFL_MIRROR_COPIED[c:GetControler()][te])) then
					c:RegisterFlagEffect(m,0,0,1)
					local sg=Duel.GetMatchingGroup(function(c) return c:GetOriginalCode()==m and c:IsAbleToDeck() end,c:GetControler(),LOCATION_HAND,0,nil)
					if c:GetFlagEffect(m)>=4 and c:IsLocation(LOCATION_DECK) and c:IsAbleToHand() and #sg>0 and Duel.SelectEffectYesNo(c:GetControler(),c,aux.Stringid(m,0)) then
						local sc=sg:GetFirst()
						if #sg>1 then
							Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_TODECK)
							sc=sg:Select(c:GetControler(),1,1,nil)
						end
						Duel.ConfirmCards(1-c:GetControler(),sc)
						Duel.SendtoHand(c,nil,REASON_RULE)
						Duel.ConfirmCards(1-c:GetControler(),c)
						Duel.SendtoDeck(sc,nil,2,REASON_RULE)
						Duel.ShuffleDeck(c:GetControler())
						PNFL_MIRROR_MULTI=PNFL_MIRROR_MULTI or {}
						PNFL_MIRROR_MULTI[c:GetOriginalCode()]=true
					end
				end
			end
			return res
		end
	end
end