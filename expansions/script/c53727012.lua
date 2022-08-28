local m=53727012
local cm=_G["c"..m]
cm.name="电脑深域N 解址死装"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(m)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(function(e)return Duel.GetFlagEffect(e:GetHandler():GetControler(),m)==0 end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	if not cm.check then
		cm.check=true
		cm[0]=Card.SetMaterial
		Card.SetMaterial=function(card,group)
			if card:IsCode(53727002) then
				group:ForEach(Card.RegisterFlagEffect,m,RESET_CHAIN,0,1)
				card:RegisterFlagEffect(m+33,RESET_CHAIN,0,1)
			end
			return cm[0](card,group)
		end
		cm[1]=Duel.SendtoGrave
		Duel.SendtoGrave=function(tg,reason)
			local res={}
			local g=Group.__add(tg,tg)
			local f=function(c)
				local p=c:GetControler()
				if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)<5 then return false end
				return Duel.GetDecktopGroup(p,5):FilterCount(Card.IsAbleToGrave,nil)>0 and c:IsHasEffect(m) and c:GetFlagEffect(m)>0
			end
			if reason==REASON_EFFECT+REASON_MATERIAL+REASON_FUSION and aux.GetValueType(tg)=="Group" and Duel.IsExistingMatchingCard(function(c)return c:GetFlagEffect(m+33)>0 end,0,0xff,0xff,1,nil) and g:IsExists(f,1,nil) then
				local mc=Duel.GetFirstMatchingCard(function(c)return c:GetFlagEffect(m+33)>0 end,0,0xff,0xff,nil)
				mc:ResetFlagEffect(m+33)
				local sg=g:Filter(f,nil)
				g:ForEach(Card.ResetFlagEffect,m)
				for tc in aux.Next(sg) do
					local p=tc:GetControler()
					if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)>4 and Duel.GetFlagEffect(p,m)==0 then
						if tc:IsFacedown() then Duel.ConfirmCards(1-p,tc) end
						Duel.Hint(HINT_CARD,0,m)
						Duel.ConfirmDecktop(p,5)
						local dg=Duel.GetDecktopGroup(p,5):Filter(function(c,mc)return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsCanBeFusionMaterial(mc)end,nil,mc)
						if #dg>0 then
							table.insert(res,p)
							Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
							local tgg=dg:Select(p,1,1,nil)
							g:Merge(tgg)
							g:RemoveCard(tc)
						end
						Duel.RegisterFlagEffect(p,m,RESET_PHASE+PHASE_END,0,1)
					end
				end
				mc:SetMaterial(g)
			end
			return cm[1](g,reason)
		end
	end
end
