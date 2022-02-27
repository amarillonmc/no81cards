local m=53799216
local cm=_G["c"..m]
cm.name="木毛的爱女 RI"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(function(e)return e:GetHandler():IsCanBeSpecialSummoned(e,0,e:GetHandler():GetControler(),false,false) and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 and e:GetHandler():GetFlagEffect(m)==0 end)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsFaceup()end)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.check then
		cm.check=true
		cm[0]=Duel.SpecialSummon
		Duel.SpecialSummon=function(targets,sumtype,sumplayer,...)
			local g=Group.__add(targets,targets)
			g:ForEach(Card.RegisterFlagEffect,m,RESET_CHAIN,0,1)
			local fing=g:Clone()
			local sg=Duel.GetMatchingGroup(function(c)return c:IsHasEffect(m)end,sumplayer,LOCATION_PZONE,0,nil)
			local pg=g:Filter(function(c)return not c:IsLocation(LOCATION_PZONE+LOCATION_GRAVE)end,nil)
			if #pg==1 and #sg>0 then Duel.Hint(HINT_CARD,0,pg:GetFirst():GetOriginalCode()) end
			if #sg>0 and #pg>0 and Duel.SelectYesNo(sumplayer,aux.Stringid(m,0)) then
				Duel.Hint(HINT_CARD,0,m)
				local sc=sg:GetFirst()
				Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
				if #sg>1 then sc=sg:Select(sumplayer,1,1,nil):GetFirst() end
				if #pg==1 then
					g:Sub(pg)
					Duel.SendtoGrave(pg,REASON_EFFECT)
				else
					Duel.Hint(HINT_SELECTMSG,sumplayer,aux.Stringid(m,1))
					local rc=pg:Select(sumplayer,1,1,nil):GetFirst()
					g:RemoveCard(rc)
					Duel.SendtoGrave(rc,REASON_EFFECT)
				end
				Duel.SpecialSummon(sc,0,sumplayer,sumplayer,false,false,POS_FACEUP)
			end
			cm[0](g,sumtype,sumplayer,...)
			fing:ForEach(Card.ResetFlagEffect,m)
		end
		cm[1]=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(targets,sumtype,sumplayer,...)
			local tc=targets
			local sg=Duel.GetMatchingGroup(function(c)return c:IsHasEffect(m)end,sumplayer,LOCATION_PZONE,0,nil)
			if not tc:IsLocation(LOCATION_PZONE+LOCATION_GRAVE) and #sg>0 then Duel.Hint(HINT_CARD,0,tc:GetOriginalCode()) end
			if #sg>0 and not tc:IsLocation(LOCATION_PZONE+LOCATION_GRAVE) and Duel.SelectYesNo(sumplayer,aux.Stringid(m,0)) then
				Duel.Hint(HINT_CARD,0,m)
				local sc=sg:GetFirst()
				Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
				if #sg>1 then sc=sg:Select(sumplayer,1,1,nil):GetFirst() end
				Duel.SendtoGrave(tc,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,sumplayer,sumplayer,false,false,POS_FACEUP)
				tc=sc
			end
			cm[1](tc,sumtype,sumplayer,...)
		end
		cm[2]=Duel.SynchroSummon
		Duel.SynchroSummon=function(p,c,tuner)
			local sg=Duel.GetMatchingGroup(function(c)return c:IsHasEffect(m)end,p,LOCATION_PZONE,0,nil)
			if #sg>0 and Duel.SelectYesNo(p,aux.Stringid(m,0)) then
				Duel.Hint(HINT_CARD,0,m)
				local sc=sg:GetFirst()
				Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
				if #sg>1 then sc=sg:Select(sumplayer,1,1,nil):GetFirst() end
				Duel.SendtoGrave(c,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEUP)
			end
		end
		cm[3]=Duel.XyzSummon
		Duel.XyzSummon=function(p,c,...)
			local sg=Duel.GetMatchingGroup(function(c)return c:IsHasEffect(m)end,p,LOCATION_PZONE,0,nil)
			if #sg>0 and Duel.SelectYesNo(p,aux.Stringid(m,0)) then
				Duel.Hint(HINT_CARD,0,m)
				local sc=sg:GetFirst()
				Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
				if #sg>1 then sc=sg:Select(sumplayer,1,1,nil):GetFirst() end
				Duel.SendtoGrave(c,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEUP)
			end
		end
		cm[4]=Duel.LinkSummon
		Duel.LinkSummon=function(p,c,...)
			local sg=Duel.GetMatchingGroup(function(c)return c:IsHasEffect(m)end,p,LOCATION_PZONE,0,nil)
			if #sg>0 and Duel.SelectYesNo(p,aux.Stringid(m,0)) then
				Duel.Hint(HINT_CARD,0,m)
				local sc=sg:GetFirst()
				Duel.Hint(HINT_SELECTMSG,sumplayer,HINTMSG_SPSUMMON)
				if #sg>1 then sc=sg:Select(sumplayer,1,1,nil):GetFirst() end
				Duel.SendtoGrave(c,REASON_EFFECT)
				Duel.SpecialSummon(sc,0,p,p,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
