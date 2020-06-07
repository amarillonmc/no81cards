--鹦鹉螺型异生兽 梅嘎福拉什
if not pcall(function() require("expansions/script/c25000033") end) then require("script/c25000033") end
local m,cm=rscf.DefineCard(25000044)
function cm.initial_effect(c)
	rssb.LinkSummonFun(c,2) 
	local e2=rsef.FV_LIMIT(c,"dis",nil,cm.tg,{LOCATION_MZONE,LOCATION_MZONE })
	local e3=rsef.STO(c,EVENT_LEAVE_FIELD,{m,1},nil,"rm","de,dsp",rssb.lfucon,nil,rsop.target(cm.rmfilter,"rm",LOCATION_DECK),cm.rmop)
	--force mzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e1:SetCondition(cm.frccon)
	e1:SetValue(cm.frcval)
	c:RegisterEffect(e1)  
end
function cm.frccon(e)
	return e:GetHandler():GetSequence()>4 and not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function cm.cfilter(c)
	return c:GetSummonLocation()&LOCATION_EXTRA ~=0
end
function cm.frcval(e,c,fp,rp,r)
	return e:GetHandler():GetLinkedZone() | 0x600060
end
function cm.tg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.rmfilter(c)
	return rssb.rmfilter(c) and rssb.IsSetM(c)
end
function cm.rmop(e,tp)
	rsop.SelectRemove(tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil,{POS_FACEDOWN,REASON_EFFECT })
end