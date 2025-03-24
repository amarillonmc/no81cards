if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53796138
local cm=_G["c"..m]
cm.name="规则守护者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(m)
	e1:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.adjust)
		Duel.RegisterEffect(ge1,0)
		cm[1]=Duel.CreateToken
		Duel.CreateToken=function(tp,code)
			local tc=cm[1](tp,code)
			if tc then tc:RegisterFlagEffect(m,0,0,0) end
			return tc
		end
		cm[2]=Duel.MoveToField
		Duel.MoveToField=function(sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 and not sc:IsType(TYPE_TOKEN) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[2](sc,...) end
		end
		cm[3]=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 and not c:IsType(TYPE_TOKEN)end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else tg:ForEach(Card.ResetFlagEffect,m) return cm[3](tg,...) end
		end
		cm[4]=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 and not sc:IsType(TYPE_TOKEN) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else sc:ResetFlagEffect(m) return cm[4](sc,...) end
		end
		cm[5]=Duel.SendtoDeck
		Duel.SendtoDeck=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[5](tg,...) end
		end
		cm[6]=Duel.SendtoExtraP
		Duel.SendtoExtraP=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[6](tg,...) end
		end
		cm[7]=Duel.SendtoGrave
		Duel.SendtoGrave=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[7](tg,...) end
		end
		cm[8]=Duel.SendtoHand
		Duel.SendtoHand=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[8](tg,...) end
		end
		cm[9]=Duel.Remove
		Duel.Remove=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[9](tg,...) end
		end
		cm[10]=Duel.Overlay
		Duel.Overlay=function(sc,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			tg=Group.__add(tg,tg)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[10](sc,tg) end
		end
		cm[11]=Duel.Destroy
		Duel.Destroy=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[11](tg,...) end
		end
		cm[12]=Duel.Equip
		Duel.Equip=function(tp,sc,ec,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[12](tp,sc,ec,...) end
		end
		cm[13]=Duel.Summon
		Duel.Summon=function(tp,sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[13](tp,sc,...) end
		end
		cm[14]=Duel.MSet
		Duel.MSet=function(tp,sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[14](tp,sc,...) end
		end
		cm[15]=Duel.SSet
		Duel.SSet=function(tp,tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[15](tp,tg,...) end
		end
		cm[16]=Duel.Release
		Duel.Release=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[16](tg,...) end
		end
		local f1=Card.SetEntityCode
		local f2=Card.SetCardData
		local f3=Card.ReplaceEffect
		Frame_Replace_Check_1={}
		Frame_Replace_Check_2={}
		Frame_Replace_Check_4=false
		Card.SetEntityCode=function(sc,code,...)
			local ocode=sc:GetOriginalCode()
			if sc:GetFlagEffect(m+500)<=0 then sc:RegisterFlagEffect(m+500,0,0,0,ocode) end
			if not sc:IsOnField() and ocode~=11410000 and code~=sc:GetFlagEffectLabel(m+500) then
				Frame_Replace_Check_1[sc]=code
			end
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if Frame_Replace_Check_2[sc] and Frame_Replace_Check_2[sc]==code and #g>0 then
				Frame_Replace_Check_1[sc]=nil
				Frame_Replace_Check_2[sc]=nil
				f3(sc,sc:GetFlagEffectLabel(m+500),0)
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return f1(sc,code,...) end
		end
		Card.SetCardData=function(sc,data,code)
			if Frame_Replace_Check_4 then return 0 end
			if data==CARDDATA_CODE then
				local ocode=sc:GetOriginalCode()
				if sc:GetFlagEffect(m+500)<=0 then sc:RegisterFlagEffect(m+500,0,0,0,ocode) end
			end
			--[[elseif data=CARDDATA_TYPE then Frame_Replace_Check_3[sc][data]=sc:GetOriginalType()
			elseif data=CARDDATA_LEVEL then Frame_Replace_Check_3[sc][data]=sc:GetOriginalLevel()
			elseif data=CARDDATA_ATTRIBUTE then Frame_Replace_Check_3[sc][data]=sc:GetOriginalAttribute()
			elseif data=CARDDATA_RACE then Frame_Replace_Check_3[sc][data]=sc:GetOriginalRace()
			elseif data=CARDDATA_ATTACK then Frame_Replace_Check_3[sc][data]=sc:GetTextAttack()
			elseif data=CARDDATA_DEFENSE then Frame_Replace_Check_3[sc][data]=sc:GetTextDefense()
			elseif data=CARDDATA_LSCALE then Frame_Replace_Check_3[sc][data]=sc:GetOriginalLeftScale()
			elseif data=CARDDATA_RSCALE then Frame_Replace_Check_3[sc][data]=sc:GetOriginalRightScale()
			elseif data=CARDDATA_LINK_MARKER then Frame_Replace_Check_3[sc][data]=sc:GetOriginalLinkMarker() end]]--
			if data==CARDDATA_CODE and not sc:IsOnField() and ocode~=11410000 and code~=sc:GetFlagEffectLabel(m+500) then
				Frame_Replace_Check_1[sc]=code
			end
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if Frame_Replace_Check_2[sc] and Frame_Replace_Check_2[sc]==code and #g>0 then
				Frame_Replace_Check_1[sc]=nil
				Frame_Replace_Check_2[sc]=nil
				Frame_Replace_Check_4=true
				f1(sc,sc:GetFlagEffectLabel(m+500),true)
				f3(sc,sc:GetFlagEffectLabel(m+500),true)
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return f2(sc,data,code) end
		end
		Card.ReplaceEffect=function(sc,code,...)
			local ocode=sc:GetOriginalCode()
			if sc:GetFlagEffect(m+500)<=0 then sc:RegisterFlagEffect(m+500,0,0,0,ocode) end
			if not sc:IsOnField() and ocode~=11410000 and code~=sc:GetFlagEffectLabel(m+500) then
				Frame_Replace_Check_2[sc]=code
			end
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if Frame_Replace_Check_1[sc] and Frame_Replace_Check_1[sc]==code and #g>0 then
				Frame_Replace_Check_1[sc]=nil
				Frame_Replace_Check_2[sc]=nil
				f1(sc,sc:GetFlagEffectLabel(m+500),true)
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				if sc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(sc:GetControler()) end
				if sc:IsLocation(LOCATION_EXTRA) then Duel.ShuffleExtra(sc:GetControler()) end
				if sc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(sc:GetControler()) end
				return 0
			else return f3(sc,code,...) end
		end
		--[[local f1=Card.SetEntityCode
		Card.SetEntityCode=function(sc,code,...)
			local ocode=sc:GetOriginalCode()
			if sc:GetFlagEffect(m+500)<=0 then sc:RegisterFlagEffect(m+500,0,0,0,ocode) end
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if not sc:IsOnField() and ocode~=11410000 and code~=sc:GetFlagEffectLabel(m+500) and #g>0 then
				Frame_Replace_Check=true
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return f1(sc,code,...) end
		end
		local f2=Card.ReplaceEffect
		Card.ReplaceEffect=function(sc,code,...)
			if Frame_Replace_Check then
				Frame_Replace_Check=false
				return 0
			else return f2(sc,code,...) end
		end]]--
	end
end
function cm.adjust(e,tp,eg,ep,ev,re,r,rp)
	Frame_Replace_Check_1={}
	Frame_Replace_Check_2={}
	Frame_Replace_Check_4=false
end
